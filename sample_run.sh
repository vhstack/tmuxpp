# Beispiel Tmux Start Skript 
# Eine Session 'Work' mit drei Fenstern (edit, bash und support) 
# wird gestartet und verbunden.
tmux new-session -d -s Work -n edit\; \
  new-window -n bash \; \
  new-window -n support \; \
  select-window -t Work:1 \; \
  attach-session -t Work
