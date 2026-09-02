<p align="right">
  <a href="README.md"><img src="assets/flag-de.png" width="16" height="12" alt="Deutsch" title="Zur deutschen Version wechseln" /></a>  
  <a href="README.en.md"><img src="assets/flag-gb.png" width="16" height="12" alt="English" title="Switch to English" /></a>  
  <a href="README.ru.md"><img src="assets/flag-ru.png" width="16" height="12" alt="Русский" title="Переключиться на русскую версию" /></a>
</p>

# <img src="assets/vhstack.svg" width="28" height="28" alt="vhstack" style="vertical-align:middle; margin-right: 6px;" /> tmuxpp – tmux that just works

[![Version](https://img.shields.io/github/v/tag/vhstack/tmuxpp?label=version&sort=semver&color=8aadf4)](https://github.com/vhstack/tmuxpp/tags)

[![CI](https://github.com/vhstack/tmuxpp/actions/workflows/ci.yml/badge.svg)](https://github.com/vhstack/tmuxpp/actions/workflows/ci.yml)

This Tmux configuration is designed for enhanced usability, featuring intuitive keybindings, true-color support, 
and mouse and clipboard integration — with no plugin manager involved.
The example script `sample_run.sh` automatically sets up and launches a session with multiple windows.  

![tmuxpp – sessions under control: windows, panes, mouse copy/paste](assets/sessions.gif)

tmuxpp is part of [vhstack](https://github.com/vhstack/vhstack). There, a single command sets up prompt, tmux and Neovim together:

```bash
curl -sL https://raw.githubusercontent.com/vhstack/vhstack/main/install.sh | bash
```

## 📥 Installation

### 1. Install Tmux

If Tmux is not yet installed:

```bash
sudo apt install tmux    # Debian/Ubuntu
brew install tmux        # macOS
```
For more information, see the [**Tmux Wiki**](https://github.com/tmux/tmux/wiki).

### 2. Set the TERM Variable

In your `~/.bashrc`, set the `TERM` variable:

```bash
export TERM=xterm-256color
```

### 3. Clone the Repository and Apply the Configuration

```bash
git clone --depth 1 https://github.com/vhstack/tmuxpp.git ~/.tmux
rm -rf ~/.tmux/.git ~/.tmux/assets ~/.tmux/README*.md
ln -s ~/.tmux/tmux.conf ~/.tmux.conf
```
Keep `clipboard.sh` and `install_win32yank.sh` in place — both are used for clipboard support (see below).

### 4. WSL only: fast clipboard

```sh
sh ~/.tmux/install_win32yank.sh
```

Sets up `win32yank.exe` and makes pasting roughly four times as fast ([details](#win32yankexe-on-wsl)). Not needed on any other system.

## ⌨️ Keybindings

- **Prefix Key:** `Ctrl + A` (instead of `Ctrl + B`)
- **Windows & Panes:**
  - `Prefix + +` → Create a new session
  - `Prefix + c` → Create a new window
  - `Prefix + ,` → Rename the window
  - `Prefix + $` → Rename the session
  - `Prefix + |` → Split vertically (panes side by side)
  - `Prefix + -` → Split horizontally (panes stacked)
  - `Prefix + b` → Break the pane out into its own window
  - `Prefix + x` → Close the pane
  - `Prefix + &` → Close the window
  - `Prefix + s` → Session tree, sorted by name
- **Navigation:**
  - `Prefix + ←,→,↑,↓` → Navigate between panes
  - `Alt + →` / `Alt + ←` → Switch between windows
  - `Ctrl + Alt + →` / `Ctrl + Alt + ←` → Move windows
- **Resize Panes:**
  - `Prefix + j/k/h/l` → Resize panes (repeatable)
  - `Prefix + z` → Maximize/restore pane
- **Mouse:**
  - Wheel → Scroll the history buffer (3 lines per notch; copy mode is entered automatically and left again at the bottom)
  - Drag → Select, and copy to the clipboard on release
  - Double-click / triple-click → Copy word / line
  - Right-click → Paste from the clipboard
  - Right-click on a window name in the status bar → window menu (rename, swap, close)
  - Right-click on the session name on the left → session menu (rename, renumber windows, new session or window)
  - `Prefix + m` → Toggle mouse support on/off
  - `Prefix + <` → Window menu from the keyboard
  - `Prefix + >` or `Alt + right-click` → Pane context menu
- **Copy Mode (vi keys):**
  - `Ctrl + PageUp` or `Prefix + [` → Enter copy mode
  - `v` → Start selection, `y` → Copy, `q` → Leave
  - `Prefix + ]` → Paste from the tmux buffer
  - History: 50,000 lines per pane
- **Reload Configuration:**
  - `Prefix + r`

## 📋 Clipboard

`clipboard.sh` connects tmux to the system clipboard. Keep the file next to `tmux.conf` (the path is resolved when the config loads, `~/.tmux/clipboard.sh` being the default). The matching tool is detected automatically:

| Platform | Tool | Installation |
| --- | --- | --- |
| WSL / Windows | `win32yank.exe` (recommended), otherwise `clip.exe` / `powershell.exe` | `sh ~/.tmux/install_win32yank.sh` |
| macOS | `pbcopy` / `pbpaste` | already present |
| Linux (Wayland) | `wl-copy` / `wl-paste` | `sudo apt install wl-clipboard` |
| Linux (X11) | `xclip` or `xsel` | `sudo apt install xclip` |

Copying runs on two tracks: once through the local tool, once through OSC 52. The latter is an escape sequence, so the text travels in the same stream as everything else on the screen. That is how it reaches the clipboard of the machine you are really sitting at, across SSH as well, with nothing installed on the server. All it takes is a terminal that plays along: Windows Terminal, WezTerm, kitty, iTerm2 and Alacritty do.

The way back is closed. A terminal that hands over its clipboard on request hands it to every program allowed to write to the screen. A `cat` on a crafted file would be enough to read along. Terminals refuse to answer for that reason, and pasting needs a tool on the machine: `win32yank.exe` or `powershell.exe` on Windows, `pbpaste` on macOS, `wl-paste` or `xclip` on Linux. With none of them around, `clipboard.sh` falls back to tmux's own buffer, that is, to whatever was selected inside tmux last.

Each list is tried top to bottom. Times measured on WSL (WSL2, Ubuntu, 20 runs):

| Operation | Path | Time |
| --- | --- | --- |
| Copy | `win32yank.exe` | 33 ms |
| | `iconv` + `clip.exe` | 33 ms |
| | OSC 52, always runs in addition | 5 ms |
| Paste | `win32yank.exe` | 35 ms |
| | `powershell.exe Get-Clipboard` | 165 ms, 340 ms on the first call |
| | tmux buffer, when no tool is found | 3 ms |

Add roughly 5 ms for the tmux call itself. Copying is therefore quick either way. Only pasting without `win32yank.exe` is expensive. For the terminal's native selection, e.g. across multiple panes, hold `Shift` while dragging or turn the mouse off with `Prefix + m`.

### win32yank.exe on WSL
The table above shows what `win32yank.exe` is good for: pasting, which drops from roughly 175 ms to 45 ms. For copying it makes no difference, because `clip.exe` lives in `system32` itself and starts just as fast. If the PowerShell path is fine for you, you can skip the rest of this section. `install_win32yank.sh` sets it up:
```sh
sh ~/.tmux/install_win32yank.sh           # install
sh ~/.tmux/install_win32yank.sh --force   # download again
sh ~/.tmux/install_win32yank.sh --remove  # remove again
```
The script downloads the pinned release [win32yank v0.1.1](https://github.com/equalsraf/win32yank), verifies the SHA256 of both the archive and the `.exe`, and puts the tool in `%LOCALAPPDATA%\win32yank`, that is, on the Windows filesystem. This is deliberate: with the `.exe` on the WSL filesystem, Windows loads it through `\\wsl.localhost` and needs more than twice as long. Only a symlink goes into the PATH (`~/.local/bin`); the path itself is recorded in `~/.cache/tmuxpp/win32yank.path`. Then press `Prefix + r`.

## 🎨 Color & Theme

- True-color support enabled
- Selectable themes (via `@theme` in `tmux.conf`): `vhstack`, `vhstack_lite`, `catppuccin`
- `vhstack` and `catppuccin` require a Nerd Font (patched font) for the icons in the status bar and prompts; `vhstack_lite` is the variant without one — pure ASCII
- `vhstack` theme enabled by default
- Messages, copy mode and context menus follow the theme colors (menus need tmux 3.4 or newer)

The configuration works without a plugin manager. Only the optional `catppuccin` theme needs a plugin — clone it once, then press `Prefix + r`:
```sh
git clone --depth 1 -b v2.1.3 https://github.com/catppuccin/tmux ~/.tmux/plugins/tmux
rm -rf ~/.tmux/plugins/tmux/.git
```

---

MIT License · part of [vhstack](https://github.com/vhstack/vhstack)
