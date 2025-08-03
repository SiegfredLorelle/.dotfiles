window_name="$1"

# Define icons
TERMINAL_ICON=""
NEOVIM_ICON=""
FILE=""

# Icon mapping logic
case "$window_name" in
    "nvim"|"vim"|"neovim")
        echo "$NEOVIM_ICON"
        ;;
    "zsh"|"bash"|"terminal")
        echo "$TERMINAL_ICON"
        ;;
    *)
        echo "$FILE"
        ;;
esac
