window_name="$1"

# Define icons
TERMINAL_ICON=""
NEOVIM_ICON=""
TMUX_ICON=""
GIT_ICON=""
CLAUDE_ICON="󰚩"
PYTHON_ICON=""
NODE_ICON=""
DOCKER_ICON=""
MONITOR_ICON="󰨇"
SSH_ICON="󰣀"
DOCS_ICON="󱓷"
# Any other running program; the old file icon read as "a file", not a process.
PROGRAM_ICON="󰘔"
# Icon mapping logic
case "$window_name" in
    "nvim"|"vim"|"neovim")
        echo "$NEOVIM_ICON"
        ;;
    "zsh"|"bash"|"terminal")
        echo "$TERMINAL_ICON"
        ;;
    "[tmux]"|"tmux")
        echo "$TMUX_ICON"
        ;;
    "git"|"lazygit"|"gh")
        echo "$GIT_ICON"
        ;;
    "claude")
        echo "$CLAUDE_ICON"
        ;;
    "python"|"python3"|"uv"|"ipython")
        echo "$PYTHON_ICON"
        ;;
    "node"|"npm"|"pnpm"|"bun"|"npx")
        echo "$NODE_ICON"
        ;;
    "docker"|"lazydocker")
        echo "$DOCKER_ICON"
        ;;
    "btop"|"htop"|"top")
        echo "$MONITOR_ICON"
        ;;
    "ssh")
        echo "$SSH_ICON"
        ;;
    "man"|"less")
        echo "$DOCS_ICON"
        ;;
    *)
        echo "$PROGRAM_ICON"
        ;;
esac
