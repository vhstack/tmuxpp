<p align="right">
  <a href="README.md"><img src="https://flagcdn.com/16x12/de.png" alt="Deutsch" title="Zur deutschen Version wechseln" /></a>  
  <a href="README.en.md"><img src="https://flagcdn.com/16x12/gb.png" alt="English" title="Switch to English" /></a>  
  <a href="README.ru.md"><img src="https://flagcdn.com/16x12/ru.png" alt="Русский" title="Переключиться на русскую версию" /></a>
</p>

# Tmux Configuration

This Tmux configuration is designed for enhanced usability, featuring intuitive keybindings, true-color support, 
mouse and clipboard integration, and a selection of useful plugins.
The example script `sample_run.sh` automatically sets up and launches a session with multiple windows.  

![Screenshot](assets/screenshot.png)

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
Keep `clipboard.sh` in place — it is required for clipboard support (see below).

### 4. Install TPM (Tmux Plugin Manager)

```bash
git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
rm -rf ~/.tmux/plugins/tpm/.git
```
More details can be found in the[**TPM-Repository**](https://github.com/tmux-plugins/tpm).

### 5. Install Plugins

Start Tmux and press:

```tmux
Prefix + I    # Installs the plugins
```

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
  - `Prefix + m` → Toggle mouse support on/off
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
| WSL / Windows | `clip.exe`, `powershell.exe` (optionally `win32yank.exe`) | already present |
| macOS | `pbcopy` / `pbpaste` | already present |
| Linux (Wayland) | `wl-copy` / `wl-paste` | `sudo apt install wl-clipboard` |
| Linux (X11) | `xclip` or `xsel` | `sudo apt install xclip` |

Copying also sends the text to the terminal you are sitting at via OSC 52. That path needs no tool on the machine, so it works on a server without X/Wayland and across SSH — provided the terminal supports OSC 52 (Windows Terminal, WezTerm, kitty, iTerm2, Alacritty).
Pasting cannot use it: for security reasons OSC 52 may only write, not read. Without a local tool, right-click therefore pastes tmux's own buffer — exactly what was last selected inside tmux. `Prefix + ]` does the same.
For the terminal's native selection, e.g. across multiple panes, hold `Shift` while dragging or turn the mouse off with `Prefix + m`.

## 📦 Plugins

Managed using TPM:

- `christoomey/vim-tmux-navigator` → Vim-style pane navigation
- `tmux-plugins/tmux-sessionist` → Session management

## 🎨 Color & Theme

- True-color support enabled
- Selectable themes (via `@theme` in `tmux.conf`): `vhstack`, `vhstack_lite`, `catppuccin`
- `vhstack` theme enabled by default

---

You're now ready to work more efficiently in your Tmux sessions! 🚀
