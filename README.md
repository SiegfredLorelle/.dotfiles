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
3.  **Required Applications:** To fully utilize these dotfiles, you'll need to install the corresponding applications. If an application isn't installed, Stow will still create the symlink, but the configuration won't take effect until the application is present.

    **Not yet working: packages are not yet modularized**
    For example, if you're using `zsh`, `hyprland`, and `neovim`, you would install them like so:

    ```bash
    sudo pacman -S zsh hyprland kitty wofi
    ```

    #### Before proceeding make sure the following are installed:

    - npm
    - yarn

    ```bash
    sudo pacman -S yarn npm
    ```

    #### screenshots:

    Install tmux and tmux plugin manager (tpm)

    ```bash
    sudo pacman -S hyprshot swappy
    ```

    #### tmux:

    Install tmux and tmux plugin manager (tpm)

    ```bash
    sudo pacman -S tmux
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ```

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

    * **Simulate Deployment**
        It's highly recommended to first simulate the Stow command to see what changes will be made without actually performing them.

        To simulate deploying specific directories (e.g., only `zsh` and `nvim`):
        ```bash
        stow -nv zsh nvim
        ```
        To simulate deploying all dotfiles in the repository:
        ```bash
        stow -nv .
        ```

    * **Perform Actual Deployment:**
        If the simulation looks correct, proceed with the actual deployment.

        To deploy specific directories:
        ```bash
        stow zsh nvim
        ```
        To deploy all dotfiles:
        ```bash
        stow .
        ```
        *(**Important:** If you encounter errors about existing files, you may need to manually remove the old configuration files from your home directory before running Stow, or use `stow --adopt` with caution if you want Stow to manage existing files.)*

4.  **Log Out and Log In:**
    After deploying your dotfiles, it's crucial to **log out of your current session and then log back in**. This ensures that all changes, especially those related to your shell and desktop environment configurations, take full effect.

---

## Superpowers (OpenCode Plugin)

Superpowers is an agentic skills framework for OpenCode that provides structured workflows for software development. See `.config/opencode/README.md` for installation instructions.

---
