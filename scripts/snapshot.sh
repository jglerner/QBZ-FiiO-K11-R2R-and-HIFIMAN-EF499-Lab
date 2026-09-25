#!/usr/bin/env bash
# Capture the real audio state of this machine into state/<date_time>/.
# Read-only: it changes nothing on the system. Safe to run while music plays.
set -u

REPO="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$REPO/state/$(date +%Y-%m-%d_%H%M%S)"
mkdir -p "$OUT"

# run <name> <command...>: save the command and its output (stdout+stderr) to <name>.txt
run() {
    local name=$1; shift
    { echo "\$ $*"; timeout 10 "$@"; } >"$OUT/$name.txt" 2>&1
}

# --- system and versions ---
run os             cat /etc/os-release
run kernel         uname -a
run versions       sh -c 'pipewire --version; wireplumber --version; easyeffects --version 2>/dev/null; flatpak list --app --columns=application,version | grep -iE "qbz|easy"'

# --- hardware ---
run asound-cards   cat /proc/asound/cards
run aplay          aplay -l
run usb            lsusb
run stream-hifiman cat /proc/asound/HIFIMANEF499/stream0
run stream-fiio    cat /proc/asound/R2R/stream0

# --- PipeWire / WirePlumber view ---
run pactl-info     pactl info
run sinks          pactl list short sinks
run sink-details   sh -c 'pactl list sinks | grep -E "Name:|Description:|State:|Sample Specification:|Mute:|Volume: front"'
run cards          sh -c 'pactl list cards | grep -E "Name:|alsa.card_name|Active Profile"'
run sink-inputs    sh -c 'pactl list sink-inputs | grep -E "Sink Input|Sink:|application.name|Sample Specification"'
run source-outputs sh -c 'pactl list source-outputs | grep -E "Source Output|Source:|application.name"'
run clock          pw-metadata -n settings
run links          pw-link -l

# --- what the DACs really receive, and who owns them ---
for card in HIFIMANEF499 R2R; do
    {
        for f in hw_params status; do
            echo "== /proc/asound/$card/pcm0p/sub0/$f"
            cat "/proc/asound/$card/pcm0p/sub0/$f" 2>&1
        done
        pid=$(awk '/owner_pid/{print $3}' "/proc/asound/$card/pcm0p/sub0/status" 2>/dev/null)
        [ -n "${pid:-}" ] && echo "== owner: $pid $(ps -o comm= -p "$pid" 2>/dev/null)"
    } >"$OUT/dac-$card.txt"
done

# --- QBZ ---
run qbz-running    flatpak ps
run qbz-perms      flatpak info --show-permissions com.blitzfc.qbz
[ -f "$HOME/qbz.log" ] && grep -iE "plugin|exclusive|Direct|reserv|ERROR|fallback" "$HOME/qbz.log" | tail -30 >"$OUT/qbz-log-excerpt.txt"

# --- live config files and difference with the repo ---
run live-configs   sh -c 'for f in $(find ~/.config/pipewire ~/.config/wireplumber -type f | sort); do echo "===== $f"; cat "$f"; done'
for d in pipewire wireplumber; do
    diff -ru "$REPO/config/$d" "$HOME/.config/$d"
done >"$OUT/config-diff.txt" 2>&1
run wp-state       ls -la "$HOME/.local/state/wireplumber"
run ee-presets     sh -c 'ls -la ~/.config/easyeffects/output ~/.config/easyeffects/irs 2>&1'

# --- recent errors ---
run journal        sh -c 'journalctl --user -b --no-pager | grep -iE "wireplumber|pipewire" | grep -iE "error|warn" | tail -40'

# --- one-page summary ---
{
    echo "Snapshot $(basename "$OUT")"
    echo; echo "## Sinks";            cat "$OUT/sinks.txt"
    echo; echo "## Default";          pactl get-default-sink 2>&1
    echo; echo "## Streams";          cat "$OUT/sink-inputs.txt"
    echo; echo "## Monitors";         cat "$OUT/source-outputs.txt"
    for card in HIFIMANEF499 R2R; do
        echo; echo "## DAC $card";    grep -E "rate:|format:|closed|owner" "$OUT/dac-$card.txt"
    done
    echo; echo "## Config drift (repo vs live)"
    grep -E "^(Only in|diff )" "$OUT/config-diff.txt" || echo "none"
} >"$OUT/SUMMARY.txt"

echo "Snapshot written to: $OUT"
cat "$OUT/SUMMARY.txt"
