// tmux copy-mode stand-in: dumps the focused terminal's screen and scrollback to a
// file and opens it in Neovim in a new tab. Yanks reach the system clipboard through
// nvim's clipboard=unnamedplus; q, Esc or :q closes the tab.

import { View, div } from "gpui-kit";
import { h_flex } from "gpui-base";
import { panes, exec, home, props, closeOverlay, theme, run } from "herdr";

const HISTORY_LINES = "10000";

// A tab, not a dialog: dialog terminals can't be given the keyboard (pane.focus says
// "no such pane"), while a new tab gets it. herdr leaves a shell behind when a tab's
// program exits, so nvim closes its own tab on the way out, then returns to the tab
// copy mode started from (herdr would otherwise pick a neighbour).
function nvimArgs(returnTab) {
    // Detached, because closing the tab kills nvim before a second synchronous call could run.
    const script = `herdr-app do tab.close --confirmed true; herdr-app do tab.select --id ${returnTab}`;
    const leave = `call jobstart(['sh', '-c', '${script}'], {'detach': v:true})`;
    return [
        "-R",
        "+normal! G",
        "-c", "nnoremap <buffer> q <cmd>qa!<CR>",
        "-c", "nnoremap <buffer> <Esc> <cmd>qa!<CR>",
        "-c", `autocmd VimLeavePre * ${leave}`,
    ];
}

export default class CopyMode extends View {
    init(_props, cx) {
        this.status = "reading scrollback…";
        // The work runs here, not in the prefix popup, because that popup closes on the
        // keypress and would take a pending async task down with it.
        cx.spawn(async (cx) => {
            try {
                await this.open();
                closeOverlay(props().overlay);
            } catch (err) {
                this.status = `copy mode failed: ${err}`;
                cx.notify();
            }
        });
    }

    async open() {
        const pane = panes().find((p) => p.focused);
        const terminal = pane?.terminal;
        if (!terminal) throw "no focused terminal";
        const file = `${home()}/.cache/herdr-copy-mode/${terminal}.txt`;
        const dump = await exec("sh", [
            "-c",
            'mkdir -p "$(dirname "$2")" && hc read --lines "$3" "$1" > "$2"',
            "sh", terminal, file, HISTORY_LINES,
        ]);
        if (dump.code !== 0) throw dump.stderr.trim();
        run("tab.new", { name: "copy", argv: ["nvim", ...nvimArgs(pane.tab), file] });
    }

    render() {
        const t = theme();
        return h_flex()
            .size_full()
            .px(14)
            .items_center()
            .rounded(8)
            .bg(t.popover)
            .text_size(13)
            .text_color(t.muted)
            .child(div().child(this.status));
    }
}
