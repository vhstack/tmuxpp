# Changelog

Dieses Projekt folgt [Semantic Versioning](https://semver.org/lang/de/).

Für eine Konfigurationssammlung gilt:

- **major** — Update braucht Handarbeit (Pfade, Keybindings, Breaking Change)
- **minor** — neue Funktionen, abwärtskompatibel
- **patch** — Fehlerbehebungen, Feinschliff

## [1.3.1] — 2026-09-04

### Geändert

- Theme `vhstack`: Copy-Mode-Auswahl als Fläche im Petrol der Wallpaper-Kugel
  (`term++/assets/vhstack_bg.jpg`), nur Hintergrund — Textfarben und
  Attribute bleiben unter der Markierung erhalten (ab tmux 3.6, davor
  Terminal-Vordergrund). Vorher Button-Farben mit `bold`, gegen den
  Pane-Hintergrund kaum sichtbar.
- Theme `vhstack`: Farbrollen geschärft — Peach ist Identität (Copy-Mode-Kante
  statt Gelb), Petrol ist Pane-Welt (aktive Pane-Kante `colour66` statt Grün,
  Marke und Uhr in Petrol statt Mauve und Grün). Grün, Blau und Mauve nur noch
  als Informationsfarben in der Statusleiste.

### Behoben

- Copy-Mode-Auswahl war auf tmux-Entwicklungsständen `next-3.6` (Snapshots
  Nov 2024 bis Jun 2025) unsichtbar: Der Fallback `#{mode-style}` der neuen
  Optionen `copy-mode-selection-style`/`copy-mode-position-style` expandierte
  `#{@...}`-Farbvariablen nicht (tmux-Issue 4533, im Release 3.6 behoben).
  Alle drei Themes setzen die Optionen jetzt explizit auf `#{E:mode-style}`;
  `set -gq` hält ältere tmux-Versionen ohne diese Optionen fehlerfrei.

## [1.3.0] — 2026-09-02

### Neu

- Kontextmenüs (`Prefix + <` / `>`, Rechtsklick auf die Statusleiste)
  übernehmen die Theme-Farben (ab tmux 3.4)
- Meldungen, Eingabe-Prompt und Kommandomodus in Theme-Farben statt tmux-Gelb
- Copy-Mode-Auswahl, Suchtreffer und Marke in Theme-Farben (ab tmux 3.2)
- Uhr, `display-panes` und Popups in Theme-Farben (Popups ab tmux 3.3)
- Umbenennen-Prompts tragen das Objektsymbol aus dem Theme
  (`@icon_window`/`@icon_session`); `vhstack_lite` bleibt mit `[W]`/`[S]`
  ohne Nerd Font nutzbar
- Symbol auch im Prompt zum Anlegen einer Sitzung (`Prefix + +`)

### Geändert

- Umbenennen startet mit dem aktuellen Namen vorbefüllt statt mit leerem Feld
- `Prefix + $` ist jetzt explizit gebunden — gleiche Funktion, mit Symbol
- Aktive und inaktive Pane-Kante gestaffelt in Indexfarben statt tmux-Grün
  und Terminal-Vordergrund
- Mindestversion in den Theme-Kopfzeilen auf tmux 3.2 korrigiert (stand auf
  3.1, war schon vorher falsch)
- READMEs dokumentieren Rechtsklick-Menüs, `Prefix + <` und die
  Nerd-Font-Voraussetzung der Themes

### Behoben

- `Esc` bricht den Prompt zuverlässig ab: `status-keys` wird explizit auf
  `emacs` gesetzt, statt es tmux aus `$EDITOR` ableiten zu lassen
- Umbenennen auf einen Namen mit führendem Bindestrich scheiterte mit
  „unknown flag" — `--` ergänzt

## [1.2.1] — 2026-08-25

### Behoben

- WSL: Rechtsklick fügte bei nicht startbarem `win32yank`/`powershell` still
  den alten tmux-Puffer ein. Jetzt Meldung in der Statuszeile statt Einfügen.
- WSL: `WSL_INTEROP` per `update-environment` vom Client übernehmen, der
  Socket des Servers stirbt mit dem ersten Fenster.

## [1.2.0] — 2026-08-22

Erstes getaggtes Release. Der Stand entspricht der bisherigen Entwicklung auf
`main` (seit 2025-03-21).

### Enthalten

- `tmux.conf` mit Prefix `Ctrl+A` und `tmux-256color`
- Splits mit `|` und `-`, Pane herauslösen mit `b`, Größe ändern mit `h/j/k/l`,
  Zoom mit `z`
- Fenster wechseln mit `Alt+←/→`, verschieben mit `Ctrl+Alt+←/→`
- Sitzungen: Auswahl mit `s`, neue Sitzung mit `+`, Fenster umbenennen mit `,`
- Konfiguration neu laden mit `r`, Copy-Mode über `Ctrl+PageUp`
- Themes `theme_vhstack.conf`, `theme_vhstack_lite.conf` und
  `theme_catppuccin.conf` (Catppuccin auf v2.1.3 festgelegt)
- `clipboard.sh` mit automatischer Erkennung des Ablageziels über `@clip`
- `install_win32yank.sh` installiert win32yank v0.1.1 ins Windows-Dateisystem,
  mit SHA256-Prüfung von Archiv und `.exe`
- `sample_run.sh` als Beispiel für einen Sitzungsstart
- Versionskennung in `VERSION`, ausgewertet vom vhstack-Installer

### Hinweis

Vor diesem Tag wurde nicht versioniert. Die Startnummer spiegelt den Reifegrad
des Projekts, nicht eine Folge früherer Releases — v1.0.0 bis v1.1.x haben nie
existiert.

[1.3.0]: https://github.com/vhstack/tmuxpp/releases/tag/v1.3.0
[1.2.1]: https://github.com/vhstack/tmuxpp/releases/tag/v1.2.1
[1.2.0]: https://github.com/vhstack/tmuxpp/releases/tag/v1.2.0
