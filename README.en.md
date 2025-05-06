<p align="right">
  <a href="README.md"><img src="https://flagcdn.com/16x12/de.png" alt="Deutsch" title="Zur deutschen Version wechseln" /></a>  
  <a href="README.en.md"><img src="https://flagcdn.com/16x12/gb.png" alt="English" title="Switch to English" /></a>  
  <a href="README.ru.md"><img src="https://flagcdn.com/16x12/ru.png" alt="Русский" title="Переключиться на русскую версию" /></a>
</p>

# Tmux Configuration

This Tmux configuration is designed for enhanced usability, featuring intuitive keybindings, true-color support, 
and a selection of useful plugins.
The example script `sample_run.sh` automatically sets up and launches a session with multiple windows.  

![Screenshot](assets/screenshot.png)

## 📥 Installation

### 1. Install Tmux

If Tmux is not yet installed:

```bash
sudo apt install tmux    # Debian/Ubuntu
brew install tmux        # macOS
```

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

### 4. Install TPM (Tmux Plugin Manager)

```bash
git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
rm -rf ~/.tmux/plugins/tpm/.git
```

### 5. Install Plugins

Start Tmux and press:

```tmux
Prefix + I    # Installs the plugins
```

## ⌨️ Keybindings

- **Prefix Key:** `Ctrl + A` (instead of `Ctrl + B`)
- **Window Management:**
  - `Prefix + c` → Create a new window
  - `Prefix + ,` → Rename the window
  - `Prefix + x` → Close the window
  - `Prefix + $` → Rename the session
  - `Prefix + |` → Split pane vertically
  - `Prefix + -` → Split pane horizontally
  - `Prefix + N` → Detach pane
- **Navigation:**
  - `Prefix + ←,→,↑,↓` → Navigate between panes
  - `Alt + →` / `Alt + ←` → Switch between windows
  - `Ctrl + Alt + →` / `Ctrl + Alt + ←` → Move windows
- **Resize Panes:**
  - `Prefix + j/k/h/l` → Resize panes
  - `Prefix + m` → Maximize/restore pane
- **Reload Configuration:**
  - `Prefix + r`

## 📦 Plugins

Managed using TPM:

- `tmux-plugins/tmux-sensible` → Standard config
- `christoomey/vim-tmux-navigator` → Vim-style pane navigation
- `tmux-plugins/tmux-sessionist` → Session management

## 🎨 Color & Theme

- True-color support enabled
- `vhstack` theme is enabled
- `catppuccin` theme is included

---

You're now ready to work more efficiently in your Tmux sessions! 🚀
