#!/bin/sh
# tmuxpp -- win32yank.exe unter WSL einrichten
#
#   sh install_win32yank.sh           installieren (oder bestaetigen)
#   sh install_win32yank.sh --force   neu herunterladen, auch wenn vorhanden
#   sh install_win32yank.sh --remove  Installation wieder entfernen
#
# win32yank.exe ist unter WSL das schnellste Werkzeug fuer die Zwischenablage.
# Ein Klipp aus der Zwischenablage zu lesen dauert damit rund 35 ms statt der
# etwa 165 ms, die der Umweg ueber powershell.exe kostet (kalt sogar 340 ms).
# Fuer den Rechtsklick heisst das ungefaehr 45 ms statt 175 ms.
#
# Die .exe landet absichtlich im Windows-Dateisystem, unter
# %LOCALAPPDATA%\win32yank. Liegt sie im WSL-Dateisystem, laedt Windows sie
# ueber \\wsl.localhost und braucht mehr als das Doppelte (rund 80 ms). In den
# Linux-PATH kommt nur ein Symlink darauf; der kostet nichts.
#
# clipboard.sh findet die Installation ueber die Datei
# ~/.cache/tmuxpp/win32yank.path, die dieses Skript hinterlegt.

set -u

# Feste Version samt Pruefsummen: das Skript laedt genau dieses Release und
# nichts anderes. v0.1.1 ist seit 2023 der aktuelle Stand.
VERSION="v0.1.1"
ZIP_NAME="win32yank-x64.zip"
ZIP_URL="https://github.com/equalsraf/win32yank/releases/download/${VERSION}/${ZIP_NAME}"
ZIP_SHA256="247c9a05b94387a884b49d3db13f806b1677dfc38020f955f719be6902260cd6"
EXE_SHA256="dade5ae8b0bc1c029d18f260e30be1e89a3b9512bcc2904c038be75e80b02ff4"

POINTER="${XDG_CACHE_HOME:-$HOME/.cache}/tmuxpp/win32yank.path"

have() { command -v "$1" >/dev/null 2>&1; }
say() { printf '%s\n' "$*"; }
die() {
	printf 'Fehler: %s\n' "$*" >&2
	exit 1
}

is_wsl() {
	[ -n "${WSL_DISTRO_NAME:-}" ] && return 0
	grep -qi microsoft /proc/version 2>/dev/null
}

sha256_of() { sha256sum "$1" 2>/dev/null | cut -d' ' -f1; }

# Entpacken: unzip ist unter Ubuntu nur 'optional' und auf einer frischen
# WSL-Installation oft nicht dabei. python3 gehoert dagegen zum Grundbestand
# und bringt das Modul zipfile mit, daher der zweite Weg.
extract_exe() {
	if have unzip; then
		unzip -qo -j "$1" win32yank.exe -d "$2" 2>/dev/null &&
			[ -f "$2/win32yank.exe" ] && return 0
	fi
	if have python3; then
		python3 -m zipfile -e "$1" "$2" >/dev/null 2>&1 &&
			[ -f "$2/win32yank.exe" ] && return 0
	fi
	return 1
}

# --- Zielverzeichnis auf der Windows-Seite ---------------------------------

# Mit appendWindowsPath=false in der wsl.conf steht cmd.exe nicht im PATH --
# dann den ueblichen Systempfad direkt versuchen.
cmd_exe() {
	if have cmd.exe; then
		printf 'cmd.exe'
	elif [ -x /mnt/c/Windows/System32/cmd.exe ]; then
		printf '/mnt/c/Windows/System32/cmd.exe'
	else
		return 1
	fi
}

# %LOCALAPPDATA% einmalig ueber cmd.exe erfragen. Der Aufruf ist langsam,
# passiert aber nur bei der Installation -- clipboard.sh liest spaeter nur noch
# die hinterlegte Pfad-Datei. Das cd nach /mnt/c unterdrueckt die Warnung, die
# cmd.exe sonst zu einem UNC-Arbeitsverzeichnis ausgibt.
windows_target_dir() {
	cmdexe=$(cmd_exe) || return 1
	appdata=$(cd /mnt/c 2>/dev/null && "$cmdexe" /c 'echo %LOCALAPPDATA%' 2>/dev/null | tr -d '\r\n')
	case "$appdata" in
	?:\\*) ;;
	*) return 1 ;;
	esac
	dir=$(wslpath -u "$appdata" 2>/dev/null) || return 1
	[ -d "$dir" ] || return 1
	printf '%s/win32yank' "$dir"
}

# --- Symlink-Verzeichnis im Linux-PATH ------------------------------------

# Erstes Verzeichnis aus dem PATH nehmen, das dem Benutzer gehoert. So gewinnt
# der Symlink gegen eine eventuell vorhandene aeltere Kopie weiter hinten.
link_dir() {
	for d in "$HOME/.local/bin" "$HOME/bin"; do
		case ":$PATH:" in
		*":$d:"*) [ -d "$d" ] && [ -w "$d" ] && { printf '%s' "$d"; return 0; } ;;
		esac
	done
	printf '%s' "$HOME/.local/bin"
}

# Echte Kopien (keine Symlinks) im WSL-Dateisystem melden -- die sind langsam.
# seen sammelt die schon gemeldeten Pfade: doppelte PATH-Eintraege sind haeufig
# und sollen nicht zu doppelten Hinweisen fuehren.
warn_slow_copies() {
	seen=" "
	IFS=:
	for d in $PATH; do
		[ -n "$d" ] || continue
		case "$d" in /mnt/*) continue ;; esac
		f="$d/win32yank.exe"
		[ -f "$f" ] && [ ! -L "$f" ] || continue
		case "$seen" in *" $f "*) continue ;; esac
		seen="$seen$f "
		say "Hinweis: $f liegt im WSL-Dateisystem und ist dadurch rund"
		say "         doppelt so langsam. clipboard.sh nutzt jetzt die neue"
		say "         Installation; die Datei kann geloescht werden."
	done
	unset IFS
}

# --- entfernen -------------------------------------------------------------

do_remove() {
	exe=""
	[ -r "$POINTER" ] && exe=$(cat "$POINTER" 2>/dev/null)

	# Fehlt die Pfad-Datei, das Ziel aus einem eigenen Symlink im PATH holen --
	# sonst bliebe die .exe auf der Windows-Seite liegen.
	if [ -z "$exe" ]; then
		IFS=:
		for d in $PATH; do
			[ -n "$d" ] || continue
			case "$(readlink "$d/win32yank.exe" 2>/dev/null)" in
			*/win32yank/win32yank.exe)
				exe=$(readlink "$d/win32yank.exe")
				break
				;;
			esac
		done
		unset IFS
	fi

	if [ -n "$exe" ]; then
		dir=$(dirname "$exe")
		case "$dir" in
		*/win32yank) rm -rf "$dir" && say "Entfernt: $dir" ;;
		esac
	fi
	rm -f "$POINTER"

	# Nur die eigenen Symlinks entfernen: entweder auf den hinterlegten Pfad
	# oder auf ein Verzeichnis, das dieses Skript angelegt hat (fuer den Fall,
	# dass die Pfad-Datei schon fehlt). readlink ohne -f, weil das Ziel oben
	# gerade geloescht wurde. Ein selbst gelegter Link auf ein anderes Ziel
	# bleibt liegen.
	IFS=:
	for d in $PATH; do
		[ -n "$d" ] || continue
		f="$d/win32yank.exe"
		[ -L "$f" ] || continue
		case "$(readlink "$f" 2>/dev/null)" in
		"$exe" | */win32yank/win32yank.exe) ;;
		*) continue ;;
		esac
		rm -f "$f" && say "Entfernt: $f"
	done
	unset IFS

	say "win32yank.exe ist entfernt. clipboard.sh nutzt wieder powershell.exe."
}

# --- installieren ----------------------------------------------------------

do_install() {
	force=$1

	is_wsl || die "kein WSL erkannt -- win32yank.exe ist nur dort sinnvoll."
	have sha256sum || die "sha256sum fehlt (Paket coreutils)."
	have unzip || have python3 ||
		die "zum Entpacken fehlt unzip oder python3: sudo apt install unzip"
	have wslpath || die "wslpath fehlt -- ist das wirklich WSL?"

	target_dir=$(windows_target_dir) ||
		die "%LOCALAPPDATA% liess sich nicht ermitteln (cmd.exe erreichbar?)."
	exe="$target_dir/win32yank.exe"

	if [ "$force" = "no" ] && [ -x "$exe" ] && [ "$(sha256_of "$exe")" = "$EXE_SHA256" ]; then
		say "win32yank.exe $VERSION liegt bereits unter:"
		say "  $exe"
	else
		have curl || have wget || die "weder curl noch wget vorhanden."

		tmp=$(mktemp -d) || die "kein temporaeres Verzeichnis anlegbar."
		trap 'rm -rf "$tmp"' EXIT INT TERM

		say "Lade win32yank $VERSION ..."
		if have curl; then
			curl -fsSL "$ZIP_URL" -o "$tmp/$ZIP_NAME" || die "Download fehlgeschlagen."
		else
			wget -qO "$tmp/$ZIP_NAME" "$ZIP_URL" || die "Download fehlgeschlagen."
		fi

		got=$(sha256_of "$tmp/$ZIP_NAME")
		[ "$got" = "$ZIP_SHA256" ] ||
			die "Pruefsumme des Archivs weicht ab.
  erwartet: $ZIP_SHA256
  erhalten: $got"

		extract_exe "$tmp/$ZIP_NAME" "$tmp" ||
			die "Archiv liess sich nicht entpacken."

		got=$(sha256_of "$tmp/win32yank.exe")
		[ "$got" = "$EXE_SHA256" ] ||
			die "Pruefsumme der .exe weicht ab.
  erwartet: $EXE_SHA256
  erhalten: $got"

		mkdir -p "$target_dir" || die "$target_dir liess sich nicht anlegen."
		cp "$tmp/win32yank.exe" "$exe" || die "Kopieren nach $exe fehlgeschlagen."
		chmod +x "$exe" 2>/dev/null || :
		say "Installiert: $exe"
	fi

	# Funktionsprobe, bevor irgendetwas aktiviert wird: Symlink und Pfad-Datei
	# entstehen nur, wenn win32yank.exe wirklich funktioniert -- sonst bliebe
	# clipboard.sh an einer kaputten Installation haengen, statt auf
	# powershell.exe zurueckzufallen. Der bisherige Inhalt der Zwischenablage
	# wird vorher gesichert und hinterher wieder eingesetzt (nur Text -- ein
	# Bild in der Zwischenablage ueberlebt die Probe nicht). --lf beim
	# Sichern, sonst verdoppelt das Wiedereinsetzen mit --crlf die
	# Wagenruecklaeufe.
	before=$("$exe" -o --lf 2>/dev/null)
	if printf 'tmuxpp' | "$exe" -i --crlf 2>/dev/null &&
		[ "$("$exe" -o 2>/dev/null | tr -d '\r\n')" = "tmuxpp" ]; then
		printf '%s' "$before" | "$exe" -i --crlf 2>/dev/null || :
		say "Funktionsprobe: in Ordnung."
	else
		printf '%s' "$before" | "$exe" -i --crlf 2>/dev/null || :
		die "Funktionsprobe fehlgeschlagen -- es wurde nichts aktiviert,
clipboard.sh nutzt weiterhin powershell.exe. Erneut versuchen oder die
Datei von Hand entfernen: $exe"
	fi

	# Symlink in den PATH, damit win32yank.exe auch ausserhalb von tmux da ist
	dir=$(link_dir)
	mkdir -p "$dir" || die "$dir liess sich nicht anlegen."
	ln -sfn "$exe" "$dir/win32yank.exe" || die "Symlink in $dir fehlgeschlagen."
	say "Verlinkt:    $dir/win32yank.exe"
	case ":$PATH:" in
	*":$dir:"*) ;;
	*) say "Hinweis: $dir steht nicht im PATH -- fuer tmux reicht das aber." ;;
	esac

	# Pfad fuer clipboard.sh hinterlegen
	mkdir -p "$(dirname "$POINTER")" || die "$POINTER liess sich nicht anlegen."
	printf '%s\n' "$exe" >"$POINTER" || die "$POINTER liess sich nicht schreiben."

	warn_slow_copies
	say "Fertig. Zwischenablage in tmux neu laden: Prefix + r"
}

case "${1:-}" in
"") do_install no ;;
-f | --force) do_install yes ;;
-r | --remove) do_remove ;;
-h | --help)
	# bis zur ersten Leerzeile -- so bleibt die Hilfe richtig, auch wenn der
	# Kopfkommentar spaeter waechst
	sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'
	;;
*)
	echo "usage: ${0##*/} [--force | --remove]" >&2
	exit 2
	;;
esac
