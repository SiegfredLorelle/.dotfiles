// tmux-style prefix: keys.json binds ctrl-b to open this popup, which takes the
// keyboard, maps the next key to an app command, then closes. Esc cancels.

import { View, div } from "gpui-kit";
import { h_flex } from "gpui-base";
import { run, props, closeOverlay, theme } from "herdr";

// Keys follow tmux first, then the herdr terminal app where tmux has no binding.
const ACTIONS = {
    c: ["tab.new"],
    '"': ["pane.split", { direction: "down" }],
    "%": ["pane.split", { direction: "right" }],
    "-": ["pane.split", { direction: "down" }],
    v: ["pane.split", { direction: "right" }],
    x: ["pane.close"],
    z: ["pane.zoom"],
    h: ["pane.go", { direction: "left" }],
    j: ["pane.go", { direction: "down" }],
    k: ["pane.go", { direction: "up" }],
    l: ["pane.go", { direction: "right" }],
    left: ["pane.go", { direction: "left" }],
    down: ["pane.go", { direction: "down" }],
    up: ["pane.go", { direction: "up" }],
    right: ["pane.go", { direction: "right" }],
    n: ["tab.next"],
    p: ["tab.prev"],
    "&": ["tab.close"],
    X: ["tab.close"],
    ",": ["tab.rename"],
    T: ["tab.rename"],
    N: ["space.new"],
    "$": ["space.rename"],
    W: ["space.rename"],
    "(": ["space.prev"],
    ")": ["space.next"],
    s: ["mod.open", { name: "picker-vim" }],
    w: ["mod.open", { name: "picker-vim" }],
    b: ["layout.toggle", { id: "sidebar" }],
    "[": ["terminal.search"],
    "]": ["terminal.paste"],
    "?": ["app.help"],
};
for (let i = 1; i <= 9; i++) ACTIONS[String(i)] = ["tab.select", { index: i }];

const MODIFIER_KEYS = new Set(["shift", "control", "ctrl", "alt", "cmd", "super", "platform", "function"]);

export default class Prefix extends View {
    init(_props, cx) {
        this.handle = cx.focus_handle();
        this.handle.focus();
    }

    render(cx) {
        const t = theme();
        return h_flex()
            .id("prefix")
            .track_focus(this.handle)
            .on_key_down((e, cx) => {
                if (MODIFIER_KEYS.has(e.key)) return;
                cx.stop_propagation();
                closeOverlay(props().overlay);
                const action = ACTIONS[e.key_char] ?? ACTIONS[e.key];
                if (action && e.key !== "escape") run(action[0], action[1] ?? {});
            })
            .size_full()
            .px(14)
            .items_center()
            .gap(8)
            .rounded(8)
            .bg(t.popover)
            .text_size(13)
            .child(div().font_semibold().text_color(t.accent).child("C-b"))
            .child(div().text_color(t.muted).child("waiting for key… (? help)"));
    }
}
