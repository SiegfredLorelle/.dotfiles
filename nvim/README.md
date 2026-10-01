# nvim

Neovim config (Lua, lazy.nvim). Deploys to `~/.config/nvim`.

Most of the setup isn't in the config files. On first launch, lazy.nvim builds some
plugins and Mason installs language servers, and both need tools you install yourself.
If they're missing, nvim still starts but shows build errors.

## Dependencies

| Tool | Needed for | Required? |
|------|------------|-----------|
| `nvim` ≥ 0.11 | everything (tested on 0.12) | yes |
| `git` | lazy.nvim bootstrap + plugin installs | yes |
| `make`, `cc` (gcc/clang) | telescope-fzf-native `build = "make"`; treesitter compiles parsers (`auto_install = true`) | yes |
| `node`, `npm` | Mason: `ts_ls`, `eslint`, `tailwindcss`, `cssls`, `cssmodules_ls`, `html`, `bashls` | yes |
| `yarn` | markdown-preview `build = "cd app && yarn install"` | yes |
| `python3` + venv module | Mason installs `ruff` from PyPI | yes |
| `curl`, `unzip`, `tar`, `gzip` | Mason downloads (`lua_ls`, `qmlls`) | yes |
| `rg` (ripgrep) | telescope `live_grep` / grep | yes |
| `libsqlite3.so` | smart-open → sqlite.lua | yes |
| `fd` | faster telescope `find_files` | optional |
| `wl-copy` / `xclip` | system clipboard, obsidian `paste_img` | optional (desktop) |
| Nerd Font | icons in lualine/neo-tree (the font goes on the machine running the *terminal*, not the SSH host) | optional |
| `stylua`, `prettier`, `qmlformat` | conform formatters (not installed by Mason) | optional |

## Install

**Arch**
```bash
sudo pacman -S --needed neovim git base-devel nodejs npm yarn python curl unzip tar gzip \
    ripgrep sqlite fd wl-clipboard
```

**Debian / Ubuntu**
```bash
sudo apt install git build-essential python3 python3-venv curl unzip tar gzip \
    ripgrep libsqlite3-dev fd-find wl-clipboard
# Neovim: apt's version is too old (see Gotchas)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
# Node LTS (NodeSource, or use nvm), then yarn
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install nodejs
sudo npm install -g yarn
```

**Fedora**
```bash
sudo dnf install neovim git make gcc nodejs npm python3 curl unzip tar gzip \
    ripgrep sqlite-devel fd-find wl-clipboard
sudo npm install -g yarn
```

## After `stow nvim`

1. Install plugins (this also runs their build steps):
   ```bash
   nvim --headless "+Lazy! sync" +qa
   ```
2. Open `nvim` and wait for Mason to finish installing language servers (watch `:Mason`).
3. Run `:checkhealth` and fix anything marked ERROR.
4. WakaTime asks for an API key on first start. Paste it, or close the prompt to skip.
5. obsidian.nvim expects the vault `~/Documents/arch-obsidian`. Create it, or edit
   `lua/plugins/obsidian.lua` on machines that don't have the vault.

## Verify

```bash
nvim --headless -c 'q'                 # starts with no errors
nvim --headless "+Lazy! sync" +qa      # no "build failed" lines
```

## Gotchas

- **Ubuntu `neovim` from apt is too old** for this config (24.04 ships 0.9). Use the
  release tarball above, the AppImage, or `ppa:neovim-ppa/unstable`.
- **Ubuntu `yarn` from apt is `cmdtest`**, which is a different program. Install Yarn
  through npm (`npm install -g yarn`) or with `corepack enable`.
- **apt's `nodejs` can be old.** Use NodeSource or nvm to get the current LTS.
- **`python3-venv` is a separate package on Debian/Ubuntu.** Without it, Mason can't install `ruff`.
- **sqlite.lua loads the unversioned `libsqlite3.so`.** That file only comes with the
  dev package (`libsqlite3-dev` / `sqlite-devel`).
- **Debian/Ubuntu name the fd binary `fdfind`.** Add `ln -s "$(command -v fdfind)" ~/.local/bin/fd`
  if you want telescope to use it.
