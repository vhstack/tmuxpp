#!/bin/sh
# tmuxpp -- Zwischenablage der jeweiligen Plattform
#
#   clipboard.sh copy              Text von stdin in die Zwischenablage
#   clipboard.sh paste <pane_id>   Zwischenablage in den Pane einfuegen
#
# Wird aus tmux.conf per copy-pipe / run-shell aufgerufen.
#
# Kopiert wird auf zwei Wegen gleichzeitig: mit dem lokalen Werkzeug
# (win32yank/clip.exe, pbcopy, wl-copy, xclip, xsel) und per OSC 52 an das
# Terminal, an dem man sitzt. Der zweite Weg braucht kein Werkzeug auf dem
# Rechner und funktioniert deshalb auch auf einem Server ohne X/Wayland und
# ueber SSH hinweg. Klappt beides nicht, bleibt der Text im tmux-Buffer
# (prefix + ] fuegt ihn ein).

set -u

# Zeitlimit fuer die Werkzeuge: ein weitergeleitetes, aber unerreichbares
# DISPLAY laesst xclip sonst haengen, powershell.exe startet gemuetlich.
TIMEOUT=${TMUXPP_CLIP_TIMEOUT:-5}

have() { command -v "$1" >/dev/null 2>&1; }

is_wsl() {
	[ -n "${WSL_DISTRO_NAME:-}" ] && return 0
	grep -qi microsoft /proc/version 2>/dev/null
}

run_tool() {
	if have timeout; then
		timeout "$TIMEOUT" "$@"
	else
		"$@"
	fi
}

# --- kopieren --------------------------------------------------------------

copy_local() {
	if is_wsl; then
		if have win32yank.exe; then
			printf '%s' "$1" | run_tool win32yank.exe -i --crlf 2>/dev/null && return 0
		fi
		if have clip.exe; then
			# clip.exe erwartet UTF-16LE, sonst werden Umlaute zerlegt
			if have iconv; then
				printf '%s' "$1" | iconv -f UTF-8 -t UTF-16LE 2>/dev/null |
					run_tool clip.exe 2>/dev/null && return 0
			fi
			printf '%s' "$1" | run_tool clip.exe 2>/dev/null && return 0
		fi
	fi

	have pbcopy && printf '%s' "$1" | run_tool pbcopy 2>/dev/null && return 0
	have wl-copy && printf '%s' "$1" | run_tool wl-copy 2>/dev/null && return 0
	have xclip && printf '%s' "$1" |
		run_tool xclip -selection clipboard 2>/dev/null && return 0
	have xsel && printf '%s' "$1" |
		run_tool xsel --input --clipboard 2>/dev/null && return 0

	return 1
}

# OSC 52 direkt auf das Terminal des Clients schreiben. Der Weg ueber tmux
# selbst (set-clipboard) setzt eine Ms-Faehigkeit voraus und greift nicht in
# jeder Version, der direkte Weg dagegen immer.
copy_osc52() {
	b64=$(printf '%s' "$1" | base64 2>/dev/null | tr -d '\r\n')
	[ -n "$b64" ] || return 1
	# Groessere Selektionen weisen die meisten Terminals ab
	[ "${#b64}" -le 74000 ] || return 1

	rc=1
	for tty in $(tmux list-clients -F '#{client_tty}' 2>/dev/null); do
		[ -w "$tty" ] || continue
		printf '\033]52;c;%s\a' "$b64" >"$tty" 2>/dev/null && rc=0
	done
	return "$rc"
}

do_copy() {
	# Die Kommandosubstitution entfernt alle Zeilenumbrueche am Ende --
	# ein abschliessendes \n wuerde die eingefuegte Zeile ausfuehren.
	data=$(cat)
	[ -n "$data" ] || return 0

	copy_local "$data" || :
	copy_osc52 "$data" || :
}

# --- einfuegen -------------------------------------------------------------

# OSC 52 kann nur schreiben, nicht lesen (die Terminals lassen das aus
# Sicherheitsgruenden nicht zu). Ohne lokales Werkzeug bleibt der tmux-Buffer,
# der beim Kopieren ohnehin mitgefuellt wird.
read_clipboard() {
	txt=""

	if is_wsl; then
		if have win32yank.exe; then
			txt=$(run_tool win32yank.exe -o 2>/dev/null)
		elif have powershell.exe; then
			# OutputEncoding explizit, sonst kommt die Konsolen-Codepage
			txt=$(run_tool powershell.exe -NoProfile -NonInteractive -Command \
				'[Console]::OutputEncoding=[Text.Encoding]::UTF8; Get-Clipboard -Raw' \
				2>/dev/null)
		fi
	fi

	[ -n "$txt" ] || ! have pbpaste || txt=$(run_tool pbpaste 2>/dev/null)
	[ -n "$txt" ] || ! have wl-paste || txt=$(run_tool wl-paste --no-newline 2>/dev/null)
	[ -n "$txt" ] || ! have xclip || txt=$(run_tool xclip -selection clipboard -o 2>/dev/null)
	[ -n "$txt" ] || ! have xsel || txt=$(run_tool xsel --output --clipboard 2>/dev/null)
	[ -n "$txt" ] || txt=$(tmux show-buffer 2>/dev/null)

	printf '%s' "$txt"
}

do_paste() {
	pane="${1:?pane_id fehlt}"

	txt=$(read_clipboard | tr -d '\r')
	[ -n "$txt" ] || return 0

	printf '%s' "$txt" | tmux load-buffer -b tmuxpp_clip -
	tmux paste-buffer -b tmuxpp_clip -t "$pane" -p -d
}

case "${1:-}" in
copy) do_copy ;;
paste)
	shift
	do_paste "$@"
	;;
*)
	echo "usage: ${0##*/} copy | paste <pane_id>" >&2
	exit 2
	;;
esac
