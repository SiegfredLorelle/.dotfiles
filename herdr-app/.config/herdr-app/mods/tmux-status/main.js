// Footer that mirrors the tmux status line in tmux/.config/tmux/tmux.conf:
// space name pill, tabs with nerd-font icons (active one magenta), host pill.

import { View, div } from "gpui-kit";
import { h_flex } from "gpui-base";
import { spaces, panes, run, exec } from "herdr";

// Copied from tmux.conf so both bars stay visually identical.
const BG = "#282C34";
const LBG = "#3F4451";
const LFG = "#abb2bf";
const MAGENTA = "#c678dd";
const FONT = "JetBrainsMono Nerd Font";

// Same mapping as tmux/.config/tmux/scripts/get-window-icon.sh.
function icon(name) {
    if (["nvim", "vim", "neovim"].includes(name)) return "";
    if (["zsh", "bash", "terminal", "shell"].includes(name)) return "";
    if (["tmux", "[tmux]"].includes(name)) return "";
    if (name === "git") return "";
    return "";
}

export default class TmuxStatus extends View {
    init(_props, cx) {
        this.host = "";
        cx.spawn(async (cx) => {
            const r = await exec("hostname");
            this.host = (r.stdout ?? "").trim();
            cx.notify();
        });
    }

    render() {
        const space = spaces().find((s) => s.active);
        const pill = (text) => div().px(10).rounded(999).bg(LBG).text_color(LFG).font_weight(700).child(text);
        const tab = (c) => {
            const pane = panes().find((p) => p.tab === c.id && p.focused) ?? panes().find((p) => p.tab === c.id);
            // Unnamed tabs are called by their position; tmux shows the running program instead.
            const name = c.named ? c.name : pane?.program?.name ?? "terminal";
            return h_flex()
                .id(`tab-${c.id}`)
                .px(10)
                .gap(8)
                .rounded(999)
                .items_center()
                .cursor_pointer()
                .when(c.active, (el) => el.bg(MAGENTA).text_color(BG).font_weight(700))
                .on_click(() => run("tab.select", { id: c.id }))
                .child(icon(name.toLowerCase()))
                .child(c.zoomed ? `${name} Z` : name);
        };
        return h_flex()
            .size_full()
            .px(4)
            .items_center()
            .bg(BG)
            .text_color(LFG)
            .font_family(FONT)
            .text_size(13)
            .child(pill(space?.name ?? ""))
            .child(h_flex().pl(24).gap(6).flex_1().min_w(0).items_center().children((space?.tabs ?? []).map(tab)))
            .child(pill(this.host));
    }
}
