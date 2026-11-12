// tmux copy-mode stand-in: dumps the focused terminal's screen and scrollback to a
// file and opens it in Neovim in place of that terminal, in the same pane. Yanks reach
// the system clipboard through nvim's clipboard=unnamedplus; q, Esc or :q goes back.

import { View, div } from "gpui-kit";
import { h_flex } from "gpui-base";
import { panes, terminals, focused, exec, hc, home, props, closeOverlay, theme, run } from "herdr";

const HISTORY_LINES = "10000";
// hc read waits about 25 s for a busy terminal to go quiet, then returns only its screen
// anyway, so give up early and ask for the screen alone, which comes back at once.
const HISTORY_TIMEOUT_MS = 1500;
// hc run returns before the app has heard of the new terminal, and terminal.show on one it
// doesn't know yet is silently dropped, so keep asking until the pane really shows it.
const SHOW_ATTEMPTS = 30;
const SHOW_RETRY_MS = 100;
const DUMP = 'mkdir -p "$(dirname "$2")" && hc read --lines "$3" "$1" > "$2" && printf %s "$4" >> "$2"';

const SCREEN_ONLY_NOTE = "[copy-mode] terminal busy: screen only, no history\n";

function dump(terminal, file, lines, { timeout, note = "" } = {}) {
    return exec("sh", ["-c", DUMP, "sh", terminal, file, lines, note], timeout ? { timeout } : {});
}

function nvimArgs(pane) {
    // Detached, because nvim's terminal ends as soon as nvim exits.
    const leave = `call jobstart(['herdr-app', 'do', 'terminal.show', '--pane', '${pane}'], {'detach': v:true})`;
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
                await this.open(cx);
                closeOverlay(props().overlay);
            } catch (err) {
                this.status = `copy mode failed: ${err}`;
                cx.notify();
            }
        });
    }

    async open(cx) {
        const pane = panes().find((p) => p.focused);
        const terminal = pane?.terminal;
        if (!terminal) throw "no focused terminal";
        const file = `${home()}/.cache/herdr-copy-mode/${terminal}.txt`;
        let result = await dump(terminal, file, HISTORY_LINES, { timeout: HISTORY_TIMEOUT_MS }).catch(() => null);
        if (result?.code !== 0) result = await dump(terminal, file, "0", { note: SCREEN_ONLY_NOTE });
        if (result.code !== 0) throw result.stderr.trim();
        // A terminal without a pane, shown in this one until nvim exits; --rm removes it then.
        const started = await hc(["run", "--bg", "--rm", "--no-parent", "--json", "nvim", ...nvimArgs(pane.pane), file]);
        if (started.code !== 0) throw started.stderr.trim();
        const nvim = JSON.parse(started.stdout).address;
        for (let i = 0; i < SHOW_ATTEMPTS; i++) {
            if (terminals().some((t) => t.address === nvim)) {
                run("terminal.show", { terminal: nvim, pane: pane.pane });
                if (focused()?.shown === nvim) return;
            }
            await cx.sleep(SHOW_RETRY_MS);
        }
        throw `${nvim} not shown in ${pane.pane}; focused: ${JSON.stringify(focused())}`;
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
