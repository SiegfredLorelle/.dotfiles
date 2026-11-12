// tmux choose-session for herdr-app: lists spaces only (picker-vim lists tabs). Type to
// filter, ↑/↓ or ctrl+j/k and Enter to go, Esc to leave.

import { View, div, svg } from "gpui-kit";
import { v_flex, h_flex, InputState, Input } from "gpui-base";
import { spaces, run, theme, props, closeOverlay, shared, setShared } from "herdr";

const MARK = { ansi6: "#22a99a", ansi3: "#e3814f", ansi4: "#5b8def", ansi5: "#8b7cf6", ansi2: "#3fae6a", ansi1: "#d9649a" };

// Copied verbatim from the app's picker: every mod assigns space colors the same way,
// so this one must too or chips disagree between mods.
const PROJECT_COLORS = ["ansi6", "ansi3", "ansi4", "ansi5", "ansi2", "ansi1"];
function spaceColors() {
  const ids = new Set(spaces().map((p) => p.id));
  const kept = Object.fromEntries(Object.entries(shared("space.colors") ?? {}).filter(([id]) => ids.has(id)));
  let changed = Object.keys(kept).length !== Object.keys(shared("space.colors") ?? {}).length;
  for (const p of spaces()) {
    if (kept[p.id] || p.name === "~") continue;
    const uses = (c) => Object.values(kept).filter((v) => v === c).length;
    kept[p.id] = PROJECT_COLORS.reduce((best, c) => (uses(c) < uses(best) ? c : best));
    changed = true;
  }
  if (changed) setShared("space.colors", kept);
  return kept;
}
function spaceColor(t, p) {
  if (p.name === "~") return t.dim;
  const c = spaceColors()[p.id] ?? PROJECT_COLORS[0];
  return c.startsWith("#") ? c : (MARK[c] ?? t[c]);
}

export default class SpacePicker extends View {
  init(_props, cx) {
    this.filter = "";
    this.input = InputState.new({ placeholder: "Go to a space…" });
    this.input.on("change", (_e, cx) => { this.filter = this.input.value(); this.at = 0; cx.notify(); });
    this.input.on("submit", () => this.go(this.rows()[this.at]));
    this.input.focus();
    cx.timer.after(600, () => this.input.focus());
    this.at = null;
    this.handle = cx.focus_handle();
  }

  close() {
    closeOverlay(props().overlay);
  }

  rows() {
    const f = this.filter.toLowerCase();
    return spaces().filter((w) => !f || w.name.toLowerCase().includes(f));
  }

  go(w) {
    if (!w) return;
    this.close();
    run("space.select", { id: w.id });
  }

  glyph(t, st) {
    if (st === "working") return svg("mods/workspace-chrome/spinner.svg").size(12).flex_none().text_color(t.working).spin(900);
    return div().w(12).flex_none().text_color(t[st] ?? t.dim).child(st === "idle" ? "○" : st ? "●" : "·");
  }

  render() {
    const t = theme();
    const rows = this.rows();
    if (this.at === null) this.at = Math.max(0, rows.findIndex((w) => w.active));
    this.at = Math.max(0, Math.min(this.at, rows.length - 1));
    const sel = rows[this.at];

    const row = (w) =>
      h_flex()
        .id(`sp-${w.id}`)
        .mx(4)
        .px(10)
        .h(32)
        .flex_none()
        .rounded(7)
        .gap(10)
        .items_center()
        .cursor_pointer()
        .when(w === sel, (el) => el.bg(t.hover))
        .hover((s) => s.bg(t.hover))
        .on_click(() => this.go(w))
        .child(h_flex().size(18).flex_none().rounded(5).bg(spaceColor(t, w)).items_center().justify_center().text_size(10.5).font_bold().text_color("#ffffff").child([...w.name][0]?.toUpperCase() ?? "?"))
        .child(div().flex_1().truncate().text_color(t.foreground).when(w.active, (d) => d.font_semibold()).child(w.name))
        .when(w.status === "blocked", (el) => el.child(div().text_size(11).text_color(t.blocked).child("needs you")))
        .child(this.glyph(t, w.status))
        .child(div().text_size(11).text_color(t.dim).child(`${w.tabs.length} tab${w.tabs.length === 1 ? "" : "s"}`));

    return v_flex()
      .id("space-picker")
      .track_focus(this.handle)
      .w_full()
      .min_h(0)
      .p(18)
      .gap(10)
      .bg(t.popover)
      .text_size(13)
      .on_key_down((e, cx) => {
        const k = e.key;
        if (k === "escape") return this.close();
        if (!rows.length) return;
        // ctrl+j/k mirror the arrows; plain j/k must stay typeable into the filter.
        if (k === "down" || (k === "j" && e.modifiers.control)) this.at = (this.at + 1) % rows.length;
        else if (k === "up" || (k === "k" && e.modifiers.control)) this.at = (this.at + rows.length - 1) % rows.length;
        else return;
        cx.stop_propagation();
        cx.notify();
      })
      .child(h_flex().items_center().child(div().flex_1().text_size(15).font_semibold().text_color(t.foreground).child("Spaces")).child(div().text_size(11).text_color(t.dim).child("Esc")))
      .child(
        h_flex().h(36).flex_none().px(10).gap(8).items_center().rounded(9).border_1().border_color(t.accent).bg(t.background)
          .child(svg("mods/workspace-chrome/search.svg").size(15).text_color(t.dim))
          .child(Input.new(this.input).flex_1().h_full().text_size(12.8).text_color(t.foreground)),
      )
      .child(v_flex().id("sp-list").max_h(320).mb(6).overflow_y_scroll().children(rows.map(row)));
  }
}
