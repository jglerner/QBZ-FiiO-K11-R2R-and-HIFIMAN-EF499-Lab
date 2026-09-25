# Verification commands

Read-only unless marked. Run while music plays where noted.

## Which outputs exist, which profile, which is default
```bash
pactl list short sinks; pactl get-default-sink
pactl list sinks | grep -E "Name:|Description:"
```
Expected: `...FiiO_K11_R2R-01.analog-stereo`, `...HIFIMAN-EF499...analog-stereo`, descriptions from `51-output-priorities.conf`.

## What the player sends vs what the DAC receives (while playing)
```bash
pactl list sink-inputs | grep -E "application.name|Sample Specification|Sink:"
grep -E "rate|format" /proc/asound/HIFIMANEF499/pcm0p/sub0/hw_params
grep -E "rate|format" /proc/asound/R2R/pcm0p/sub0/hw_params
```
Stream rate = DAC rate → no resampling.

## Who owns the DAC (exclusive check)
```bash
grep owner_pid /proc/asound/HIFIMANEF499/pcm0p/sub0/status; flatpak ps | grep -i qbz; pgrep -a pipewire
```

## What is attached to a DAC (rate lock suspects)
```bash
pactl list source-outputs | grep -E "Source:|application.name"
pw-link -l | grep -i -A2 -B2 hifiman
```

## Allowed rates
```bash
pw-metadata -n settings | grep -E "rate"
```

## Direct hardware test, bypassing PipeWire (⚠ volume low)
```bash
PIPEWIRE_NODE=alsa_output.usb-HIFIMAN-EF499_HIFIMAN-EF499_SXW230918-00.analog-stereo \
  speaker-test -D pipewire -r 96000 -c 2 -t wav -l 1
```

## Recent errors
```bash
journalctl --user -b --no-pager | grep -iE "wireplumber|pipewire" | grep -iE "error|warn" | tail -20
```

## Restart the audio stack (pauses all sound)
```bash
systemctl --user restart pipewire pipewire-pulse wireplumber
```
