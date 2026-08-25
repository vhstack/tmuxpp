# Changelog

Dieses Projekt folgt [Semantic Versioning](https://semver.org/lang/de/).

Für eine Konfigurationssammlung gilt:

- **major** — Update braucht Handarbeit (Pfade, Keybindings, Breaking Change)
- **minor** — neue Funktionen, abwärtskompatibel
- **patch** — Fehlerbehebungen, Feinschliff

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

[1.2.0]: https://github.com/vhstack/tmuxpp/releases/tag/v1.2.0
