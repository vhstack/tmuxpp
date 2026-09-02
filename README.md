<p align="right">
  <a href="README.md"><img src="assets/flag-de.png" width="16" height="12" alt="Deutsch" title="Zur deutschen Version wechseln" /></a>  
  <a href="README.en.md"><img src="assets/flag-gb.png" width="16" height="12" alt="English" title="Switch to English" /></a>  
  <a href="README.ru.md"><img src="assets/flag-ru.png" width="16" height="12" alt="Русский" title="Переключиться на русскую версию" /></a>
</p>

# <img src="assets/vhstack.svg" width="28" height="28" alt="vhstack" style="vertical-align:middle; margin-right: 6px;" /> tmuxpp – Tmux, das einfach funktioniert

[![Version](https://img.shields.io/github/v/tag/vhstack/tmuxpp?label=version&sort=semver&color=8aadf4)](https://github.com/vhstack/tmuxpp/tags)

[![CI](https://github.com/vhstack/tmuxpp/actions/workflows/ci.yml/badge.svg)](https://github.com/vhstack/tmuxpp/actions/workflows/ci.yml)

Diese Tmux-Konfiguration optimiert die Bedienung durch nützliche Tastenkombinationen, True-Color-Support sowie Maus- und Zwischenablage-Unterstützung — ohne Plugin-Manager.
Das Beispielskript `sample_run.sh` konfiguriert und startet automatisch eine Session mit mehreren Fenstern.  

![tmuxpp – Sessions im Griff: Fenster, Panes, Maus-Copy/Paste](assets/sessions.gif)

tmuxpp gehört zu [vhstack](https://github.com/vhstack/vhstack). Dort richtet ein Befehl Prompt, Tmux und Neovim zusammen ein:

```bash
curl -sL https://raw.githubusercontent.com/vhstack/vhstack/main/install.sh | bash
```

## 📥 Installation

### 1. Tmux installieren
Falls Tmux noch nicht installiert ist:
```sh
sudo apt install tmux   # Debian/Ubuntu
brew install tmux       # macOS
```
Weitere Informationen findest du im [**Tmux Wiki**](https://github.com/tmux/tmux/wiki).

### 2. TERM-Variable setzen
In der Datei `~/.bashrc` die Variable `TERM` setzen:
```sh
export TERM=xterm-256color
```

### 3. Repository klonen und Konfiguration anwenden
```sh
git clone --depth 1 https://github.com/vhstack/tmuxpp.git ~/.tmux
rm -rf ~/.tmux/.git ~/.tmux/assets ~/.tmux/README*.md
ln -s ~/.tmux/tmux.conf ~/.tmux.conf 
```
`clipboard.sh` und `install_win32yank.sh` bleiben dabei liegen — beide werden für die Zwischenablage gebraucht (siehe unten).

### 4. Nur unter WSL: schnelle Zwischenablage
```sh
sh ~/.tmux/install_win32yank.sh
```
Richtet `win32yank.exe` ein und macht das Einfügen rund viermal so flott ([Details](#win32yankexe-unter-wsl)). Auf allen anderen Systemen nicht nötig.

## ⌨️ Tastenkombinationen

- **Prefix-Taste**: `Ctrl + A` (statt `Ctrl + B`)
- **Fenster & Panes:**
  - `Prefix + +` → Neue Session erzeugen
  - `Prefix + c` → Fenster anlegen
  - `Prefix + ,` → Fenster umbenennen
  - `Prefix + $` → Session umbenennen
  - `Prefix + |` → Senkrecht teilen (Panes nebeneinander)
  - `Prefix + -` → Waagerecht teilen (Panes untereinander)
  - `Prefix + b` → Pane in ein eigenes Fenster lösen
  - `Prefix + x` → Pane schließen
  - `Prefix + &` → Fenster schließen
  - `Prefix + s` → Session-Baum, nach Namen sortiert
- **Navigation:**
  - `Prefix + ←,→,↑,↓` → Zwischen Panes wechseln
  - `Alt + →` / `Alt + ←` → Zwischen Fenstern wechseln
  - `Strg + Alt + →` / `Strg + Alt + ←` → Fenster verschieben
- **Panegröße anpassen:**
  - `Prefix + j/k/h/l` → Panegröße ändern (wiederholbar)
  - `Prefix + z` → Pane maximieren/wiederherstellen
- **Maus:**
  - Mausrad → Im History-Buffer scrollen (3 Zeilen pro Rasterung, der Copy-Mode wird automatisch betreten und am Ende wieder verlassen)
  - Ziehen → Markieren, beim Loslassen in die Zwischenablage kopieren
  - Doppelklick / Dreifachklick → Wort / Zeile kopieren
  - Rechtsklick → Aus der Zwischenablage einfügen
  - Rechtsklick auf einen Fensternamen in der Statusleiste → Fenster-Menü (umbenennen, tauschen, schließen)
  - Rechtsklick auf den Sessionnamen links → Session-Menü (umbenennen, Fenster neu numerieren, neue Session oder neues Fenster)
  - `Prefix + m` → Maussteuerung an/aus
  - `Prefix + <` → Fenster-Menü über die Tastatur
  - `Prefix + >` oder `Alt + Rechtsklick` → Kontextmenü des Panes
- **Copy-Mode (vi-Tasten):**
  - `Strg + PageUp` oder `Prefix + [` → Copy-Mode starten
  - `v` → Auswahl beginnen, `y` → Kopieren, `q` → Verlassen
  - `Prefix + ]` → Aus dem tmux-Buffer einfügen
  - Verlauf: 50 000 Zeilen pro Pane
- **Konfiguration neu laden:**
  - `Prefix + r`

## 📋 Zwischenablage
`clipboard.sh` verbindet tmux mit der Zwischenablage des Systems. Die Datei muss neben der `tmux.conf` liegen (der Pfad wird beim Laden ermittelt, `~/.tmux/clipboard.sh` ist die Voreinstellung). Das passende Werkzeug wird automatisch erkannt:

| Plattform | Werkzeug | Installation |
| --- | --- | --- |
| WSL / Windows | `win32yank.exe` (empfohlen), sonst `clip.exe` / `powershell.exe` | `sh ~/.tmux/install_win32yank.sh` |
| macOS | `pbcopy` / `pbpaste` | bereits vorhanden |
| Linux (Wayland) | `wl-copy` / `wl-paste` | `sudo apt install wl-clipboard` |
| Linux (X11) | `xclip` oder `xsel` | `sudo apt install xclip` |

Kopiert wird zweigleisig: einmal mit dem lokalen Werkzeug, einmal per OSC 52. Letzteres ist eine Escape-Sequenz, der Text reist also im selben Datenstrom wie die Bildschirmausgabe. Er landet damit in der Zwischenablage des Rechners, an dem man wirklich sitzt, auch über SSH hinweg und ohne dass auf dem Server irgendetwas installiert sein muss. Mitspielen muss nur das Terminal: Windows Terminal, WezTerm, kitty, iTerm2 und Alacritty tun das.

Zurück führt dieser Weg nicht. Ein Terminal, das seine Zwischenablage auf Nachfrage preisgibt, gibt sie jedem Programm preis, das auf den Bildschirm schreiben darf. Ein `cat` auf eine präparierte Datei würde reichen, um mitzulesen, was gerade darin liegt. Die Terminals verweigern die Auskunft deshalb, und zum Einfügen braucht es ein Werkzeug auf dem Rechner: `win32yank.exe` oder `powershell.exe` unter Windows, `pbpaste` auf dem Mac, `wl-paste` oder `xclip` unter Linux. Fehlt es, fällt `clipboard.sh` auf den tmux-eigenen Buffer zurück, also auf das, was zuletzt in tmux markiert wurde.

Durchprobiert wird von oben nach unten. Zeiten unter WSL gemessen (WSL2, Ubuntu, 20 Durchläufe):

| Vorgang | Weg | Zeit |
| --- | --- | --- |
| Kopieren | `win32yank.exe` | 33 ms |
| | `iconv` + `clip.exe` | 33 ms |
| | OSC 52, läuft immer zusätzlich mit | 5 ms |
| Einfügen | `win32yank.exe` | 35 ms |
| | `powershell.exe Get-Clipboard` | 165 ms, erster Aufruf 340 ms |
| | tmux-Buffer, wenn kein Werkzeug gefunden wird | 3 ms |

Dazu kommen jeweils rund 5 ms für den tmux-Aufruf selbst. Kopieren ist damit in jedem Fall flott. Teuer ist allein das Einfügen ohne `win32yank.exe`. Für die native Auswahl des Terminals, etwa über mehrere Panes hinweg, beim Ziehen `Shift` halten oder die Maus mit `Prefix + m` abschalten.

### win32yank.exe unter WSL
Die Tabelle oben zeigt, wofür sich `win32yank.exe` lohnt: für das Einfügen, das damit von rund 175 ms auf 45 ms fällt. Beim Kopieren bringt es nichts, weil `clip.exe` selbst in `system32` liegt und genauso schnell startet. Wer mit dem PowerShell-Weg lebt, braucht das Folgende also nicht. `install_win32yank.sh` richtet es ein:
```sh
sh ~/.tmux/install_win32yank.sh           # installieren
sh ~/.tmux/install_win32yank.sh --force   # neu herunterladen
sh ~/.tmux/install_win32yank.sh --remove  # wieder entfernen
```
Das Skript lädt das festgelegte Release [win32yank v0.1.1](https://github.com/equalsraf/win32yank), prüft die SHA256-Summe von Archiv und `.exe` und legt das Werkzeug unter `%LOCALAPPDATA%\win32yank` ab, also im Windows-Dateisystem. Das ist Absicht: liegt die `.exe` im WSL-Dateisystem, lädt Windows sie über `\\wsl.localhost` und braucht mehr als das Doppelte. In den PATH kommt nur ein Symlink darauf (`~/.local/bin`), gefunden wird sie über `~/.cache/tmuxpp/win32yank.path`. Danach `Prefix + r`.

## 🎨 Farbe & Theme
- True Color aktiviert
- Auswählbare Themes (über `@theme` in `tmux.conf`): `vhstack`, `vhstack_lite`, `catppuccin`
- `vhstack` und `catppuccin` brauchen eine Nerd Font (gepatchte Schrift) für die Symbole in Statusleiste und Prompts; `vhstack_lite` ist die Variante ohne — reines ASCII
- `vhstack`-Theme standardmäßig aktiviert
- Meldungen, Copy-Mode und Kontextmenüs übernehmen die Farben des Themes (Menüs ab tmux 3.4)

Die Konfiguration kommt ohne Plugin-Manager aus. Einzig das optionale `catppuccin`-Theme braucht ein Plugin — einmalig klonen, dann `Prefix + r`:
```sh
git clone --depth 1 -b v2.1.3 https://github.com/catppuccin/tmux ~/.tmux/plugins/tmux
rm -rf ~/.tmux/plugins/tmux/.git
```

---

MIT-Lizenz · Teil von [vhstack](https://github.com/vhstack/vhstack)
