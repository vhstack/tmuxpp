# tmuxpp — „Sessions im Griff“ (Hero-GIF)
# Leiste → Fenster + Rename → Splits mit Live-Inhalt → Theme-Schwenk.

Output sessions.gif

Set Width 1000
Set Height 640
Set Framerate 15
Set FontSize 15
Set Padding 16
Set FontFamily "CaskaydiaCove Nerd Font Mono"
Set Theme "Catppuccin Mocha"
Set Shell bash
Set TypingSpeed 45ms

# ── Setup (unsichtbar): Demo-HOME auffrischen, stacktop + vlib2 + Catppuccin-Plugin bereitstellen ──
Hide
Type "SP=${VHS_DEMO_DIR:-$HOME/.cache/vhstack-demo}; FH=$SP/fakehome"
Enter
Type "cp ${VHS_TMUXCONF:-../tmux.conf} $FH/.tmux/tmux.conf; ln -sf .tmux/tmux.conf $FH/.tmux.conf; echo 'set -s escape-time 500' >> $FH/.tmux/tmux.conf"
Enter
Type `echo "bind -T copy-mode-vi DoubleClick1Pane run -d 0.15 \; send -X copy-pipe-and-cancel 'sh ~/.tmux/clipboard.sh copy'" >> $FH/.tmux/tmux.conf`
Enter
Type "mkdir -p $FH/projekte/vlib2; rm -rf $FH/projekte/stacktop; cp -r ${VHS_APP_DIR:-$HOME/projekte/stacktop} $FH/projekte/stacktop; rm -rf $FH/projekte/stacktop/build $FH/projekte/stacktop/Debug $FH/projekte/stacktop/stacktop"
Enter
Type "cp -ru ${VHS_VLIB_DIR:-$HOME/projekte/vlib2}/include ${VHS_VLIB_DIR:-$HOME/projekte/vlib2}/lib $FH/projekte/vlib2/"
Enter
Type "git -C $FH/projekte/stacktop init -qb main 2>/dev/null; git -C $FH/projekte/stacktop add -A 2>/dev/null; git -C $FH/projekte/stacktop -c user.name=vh -c user.email=vh@stack commit -qm 'stacktop: Grundgeruest' 2>/dev/null; git -C $FH/projekte/stacktop config core.pager cat"
Enter
Type "[ -r $FH/.tmux/plugins/tmux/catppuccin.tmux ] || { git clone -q --depth 1 -b v2.1.3 https://github.com/catppuccin/tmux $FH/.tmux/plugins/tmux && rm -rf $FH/.tmux/plugins/tmux/.git; }"
Enter
Type "tmux -L vhsdemo kill-server 2>/dev/null; exec $SP/stackshell $FH"
Enter
Sleep 2s
Type "alias tmux='tmux -L vhsdemo'"
Enter
Type "clear"
Enter
Sleep 500ms
Show

# ── Szene 1: tmux → Statusleiste erscheint ──
Sleep 1.5s
Type "tmux"
Sleep 400ms
Enter
Sleep 3s

# ── Szene 2: Fenster anlegen und umbenennen — Buttons füllen sich ──
Ctrl+A
Sleep 300ms
Type "c"
Sleep 1s
Ctrl+A
Sleep 300ms
Type ","
Sleep 500ms
Type "build"
Sleep 300ms
Enter
Sleep 1.5s
Ctrl+A
Sleep 300ms
Type "c"
Sleep 1s
Ctrl+A
Sleep 300ms
Type ","
Sleep 500ms
Type "run"
Sleep 300ms
Enter
Sleep 2s

# ── Szene 3: Fenster wechseln ──
Ctrl+A
Sleep 300ms
Type "2"
Sleep 2s

# ── Szene 4: Panes — Split | mit Live-Simulation, Split - und Navigation ──
Type "cd projekte/stacktop"
Sleep 300ms
Enter
Sleep 1.5s
Ctrl+A
Sleep 300ms
Type "|"
Sleep 1s
Type "cd projekte/stacktop && make && ./stacktop"
Sleep 300ms
Enter
Wait+Screen@60s /cores/
Sleep 2.5s
Ctrl+A
Sleep 300ms
Left
Sleep 800ms
Ctrl+A
Sleep 300ms
Type "-"
Sleep 1s
Type "cd projekte/stacktop"
Sleep 300ms
Enter
Sleep 1s
Ctrl+A
Sleep 300ms
Up
Sleep 800ms
Type "git log --oneline -1"
Sleep 300ms
Enter
Sleep 2s

# ── Szene 5: Doppelklick markiert den Hash — und kopiert ihn ──
Escape
Type@1ms "[<0;4;7M"
Escape
Type@1ms "[<0;4;7m"
Sleep 150ms
Escape
Type@1ms "[<0;4;7M"
Escape
Type@1ms "[<0;4;7m"
Sleep 1.8s

# ── Szene 6: Linksklick ins untere Pane, Rechtsklick fügt ein ──
Escape
Type@1ms "[<0;20;20M"
Escape
Type@1ms "[<0;20;20m"
Sleep 800ms
Type "git show --stat "
Sleep 400ms
Escape
Type@1ms "[<2;20;20M"
Escape
Type@1ms "[<2;20;20m"
Sleep 1s
Enter
Sleep 3s

# ── Finale: Build unterm laufenden Dashboard — die CPU-Kurve reagiert ──
Type "make clean && make"
Sleep 400ms
Enter
Sleep 3.5s
Sleep 2s
