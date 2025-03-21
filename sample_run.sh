# Beispiel Tmux Start Skript 
# Eine Session 'Work' mit drei Fenstern (edit, build und run) 
# wird gestartet und verbunden.
tmux new-session -d -s Work -n develop\; \
  new-window -n build \; \
  new-window -n run \; \
  select-window -t Work:1 \; \
  attach-session -t Work
