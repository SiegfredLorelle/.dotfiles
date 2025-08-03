window_name="$1"

# Define icons
TERMINAL_ICON=""
NEOVIM_ICON=""
FILE_ICON=""
TMUX_ICON=""

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
    *)
        echo "$FILE_ICON"
        ;;
esac
