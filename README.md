# My Arch Linux Dotfiles

Welcome to my personal dotfiles repository! This collection manages the configuration for various applications on my Arch Linux setup, aiming for a clean, efficient, and easily replicable workspace across different devices.

---

## Why Dotfiles?

Dotfiles are hidden configuration files (prefixed with a dot, like `.zshrc`) that control the behavior and appearance of your shell, applications, and desktop environment. Storing them in a version-controlled repository like Git offers several key advantages:

* **Easy Setup:** Quickly configure new machines to your personalized environment.
* **Version Control:** Track changes, revert to previous states, and experiment with new configurations safely.
* **Synchronization:** Keep your configurations consistent across multiple systems.
* **Backup:** A reliable backup of your customized environment.

---

## Applications Configured

This repository includes configuration files for the following applications and tools:

* **Shell:** `zsh`
* **Terminal Emulator:** `kitty`
* **Text Editor:** `neovim`
* **Terminal Multiplexer:** `tmux`
* **Tiling Window Manager:** `Hyprland`
* **Desktop Components:** `Quickshell`
* **AI Coding Agents:** `Claude Code`, `OpenCode`
<!-- * **Editor:** Neovim
* **Display Manager:** SDDM
* **Other Tools:**
    * Git
    * btop
    * wofi
    * pyenv -->

---

## Getting Started

Follow these steps to set up my dotfiles on your Arch Linux system.

### Prerequisites

Before you begin, ensure you have the following installed:

1.  **Git:** For cloning this repository.
    ```bash
    sudo pacman -S git
    ```
2.  **GNU Stow:** The symlink manager used to link dotfiles from this repository to your home directory.
    ```bash
    sudo pacman -S stow
    ```
3.  **Package dependencies:** Every package has its own `README.md` that lists the
    tools it needs, with install commands, and the manual steps to run after stowing.
    Core packages include Arch, Debian/Ubuntu and Fedora commands; desktop packages are
    Arch only. Stow skips these READMEs, so they never end up in `$HOME`.

    | Group | Package READMEs |
    |-------|-----------------|
    | core | [zsh](zsh/README.md) · [git](git/README.md) · [nvim](nvim/README.md) · [tmux](tmux/README.md) |
    | desktop | [hypr](hypr/README.md) · [quickshell](quickshell/README.md) · [kitty](kitty/README.md) · [waybar](waybar/README.md) · [wofi](wofi/README.md) · [swappy](swappy/README.md) · [opencode](opencode/README.md) · [theme](theme/README.md) · [claude](claude/README.md) · [wallpapers](wallpapers/README.md) |

    nvim has the most to install: `make`, a C compiler, Node/npm, Yarn, Python venv,
    ripgrep and sqlite are all needed before its first launch.

---

### Installation Steps

1.  **Clone the Repository**

    Clone the dotfiles repository into within your home directory (e.g., `~/.dotfiles`). Using **SSH for cloning is generally preferred** for security and convenience after initial setup.

    **Via SSH (Recommended):**

    ```bash
    cd ~
    git clone git@github.com:SiegfredLorelle/.dotfiles.git
    ```

    **Via HTTPS (If SSH is not set up):**

    ```bash
    cd ~
    git clone https://github.com/SiegfredLorelle/.dotfiles.git
    ```

2.  **Navigate to the Dotfiles Directory:**

    ```bash
    cd ~/.dotfiles
    ```

3.  **Deploy Dotfiles with Stow:**

    GNU Stow works by creating symlinks from the dotfiles in this repository to your home directory. This method is generally safer and more flexible than directly copying files, as it allows for easy updates, removal, and selective deployment.

    Each top-level directory is a Stow package (`nvim/`, `tmux/`, `hypr/`, ...), so you pick
    which ones a machine gets. Don't run `stow .`: the repo root is not a package.

    | Group | Packages | Use on |
    |-------|----------|--------|
    | core | `zsh git nvim tmux` | every machine, including headless servers |
    | desktop | `hypr kitty quickshell waybar wofi swappy opencode theme claude wallpapers` | the Arch desktop, on top of core |

    * **Simulate Deployment** (always do this first):
        ```bash
        stow -nv zsh git nvim tmux                     # core only
        stow -nv zsh git nvim tmux hypr kitty quickshell waybar wofi swappy opencode theme claude wallpapers
        ```

    * **Perform Actual Deployment:** run the same command without `-n`.
        ```bash
        stow zsh git nvim tmux
        ```
        To remove a package's symlinks: `stow -D <package>`.

        *(**Important:** If you encounter errors about existing files, you may need to manually remove the old configuration files from your home directory before running Stow, or use `stow --adopt` with caution if you want Stow to manage existing files.)*

4.  **Run each package's post-stow steps:** for example, the Lazy/Mason sync for nvim,
    TPM for tmux and `chsh` for zsh. They're listed under "After `stow <pkg>`" in each
    package's README.

5.  **Log Out and Log In:**
    After deploying your dotfiles, it's crucial to **log out of your current session and then log back in**. This ensures that all changes, especially those related to your shell and desktop environment configurations, take full effect.

---

## Superpowers (OpenCode Plugin)

Superpowers is an agentic skills framework for OpenCode that provides structured workflows for software development. See `opencode/.config/opencode/README.md` for installation instructions.

---
