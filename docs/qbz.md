# QBZ (Qobuz client)

- Flatpak `com.blitzfc.qbz` 2.1.2 (flathub, system install), KDE runtime (`org.kde.Platform`).
- Runs sandboxed: QBZ's own HiFi Wizard cannot inspect the host audio stack.
- Closing the window does **not** quit it (tray). Quit via tray/menu, or `flatpak kill com.blitzfc.qbz`.
- Start with a log: `flatpak run com.blitzfc.qbz > ~/qbz.log 2>&1 &`

## Settings → Audio (as seen 2026-09-25)

| Setting | Value seen | Target for "Pure" |
|---|---|---|
| Streaming quality | Hi-Res+ | keep |
| Limit quality to device | off | keep off (both DACs do 192k) |
| Audio backend | ALSA | keep |
| Output device | System default → changed to `HIFIMAN-EF499, front:CARD=HIFIMANEF499,DEV=0` (**BP**) | keep the BP entry |
| ALSA plugin | **pcm (Most compatible)** | **hw** ("hw is bit-perfect, plughw converts") |
| DSD playback | Native DSD (kernel support required) | keep — both DACs support native DSD; Qobuz streams PCM anyway |
| Exclusive mode | **off** | **on** |
| Reserve DAC while running | **off** | **on** |
| Volume slider | slightly below max | **100 %** |

Output device list offered by QBZ ("Bit-perfect (Hardware / Digital)"):
`FiiO K11 R2R, front:CARD=R2R,DEV=0` · `HD-Audio Generic, front:CARD=Generic_1,DEV=0` · `HIFIMAN-EF499, front:CARD=HIFIMANEF499,DEV=0`.

## HiFi Wizard

- It offered a file `~/.config/pipewire/pipewire.conf.d/99-qbz-dac-monitor-hdmi.conf` (allowed-rates) — for the **wrong device** (Monitor HDMI).
- **Not applied, on purpose:** QBZ states *"QBZ never writes these files… QBZ already pins rate, sink and exclusive mode at runtime"*,
  and our `10-rates.conf` already sets the allowed rates. A `99-…` file would override ours.

## Flatpak permissions

Original `[Session Bus Policy]` had no `org.freedesktop.ReserveDevice1` → QBZ cannot ask PipeWire to release a DAC.

Applied 2026-09-25 (user override, reversible with `flatpak override --user --reset com.blitzfc.qbz`):
```bash
flatpak override --user --own-name='org.freedesktop.ReserveDevice1.*' com.blitzfc.qbz
```
Verified: `flatpak info --show-permissions com.blitzfc.qbz | grep -i reserve` → `org.freedesktop.ReserveDevice1.*=own`.
(Note: adding `--talk-name` for the same name afterwards *replaces* `own` with `talk` — don't.)

Other relevant permissions: `devices=all` (can open `/dev/snd`), `sockets=pulseaudio`, `xdg-run/pipewire-0`.

## Log excerpt — why exclusive did not engage (2026-09-25 14:01)

```
Using backend system: Alsa (device: Some("front:CARD=HIFIMANEF499,DEV=0"), plugin: Some(Pcm))
Detected hw: device, using ALSA Direct for bit-perfect playback
Hardware confirms support for 192000Hz (card 'HIFIMANEF499', rates: [44100, 48000, 88200, 96000, 176400, 192000])
PCM mode selected, not using direct ALSA
Creating stream: 192000Hz, 2 channels, exclusive: false, plugin: Some(Pcm)
WARN 'front:CARD=HIFIMANEF499,DEV=0' not resolvable by ALSA (alias likely missing in asound.conf); trying fallback 'hw:CARD=HIFIMANEF499,DEV=0'
ERROR Backend stream creation failed: ... CPAL cannot open it ... Try the plughw plugin
WARN ... falling back to legacy
Creating MixerDeviceSink: 192000Hz, 2 channels, exclusive: false
```
Result: DAC `owner_pid` = PipeWire, rate 192000 (correct rate, but through PipeWire).

## How to verify exclusive mode

```bash
grep owner_pid /proc/asound/HIFIMANEF499/pcm0p/sub0/status; flatpak ps | grep -i qbz
grep rate /proc/asound/HIFIMANEF499/pcm0p/sub0/hw_params
grep -iE "plugin|exclusive|Direct|reserv|ERROR|fallback" ~/qbz.log | tail -10
```
Success = `plugin: Some(Hw)`, `exclusive: true`, no "falling back to legacy", and `owner_pid` = the QBZ PID shown by `flatpak ps`.
