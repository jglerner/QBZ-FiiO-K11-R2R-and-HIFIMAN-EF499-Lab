# Findings log

Each entry: **symptom → root cause → fix → verification**. Newest last.

---

## 1. TOMATE "not working" (2026-09-25)

- **Symptom:** no sound from the TOMATE on the SER 9's 3.5 mm jack.
- **Root cause:** `~/.config/wireplumber/wireplumber.conf.d/disable-analog.conf` (dated May 1)
  disables `alsa_card.pci-0000_65_00.6` (Realtek ALC897 = the 3.5 mm jacks). Journal:
  `ALSA card/device alsa_card.pci-0000_65_00.6 disabled`.
  Additionally, the old P2↔P2 cable gave only the left channel (`speaker-test ... -s 2` silent on the right).
- **Decision (user): setup B** — TOMATE fed from the **FiiO LO SE** via RCA → P2. Better DAC, simpler.
  The onboard jack stays disabled (the rule is kept on purpose).
- **Verified:** Front Left / Front Right heard on the TOMATE via FiiO LO.

## 2. Leftover configs from earlier tuning (2026-09-25)

| File | Problem | Action |
|---|---|---|
| `~/.config/wireplumber/main.lua.d/disable-analog.lua` | Lua format, ignored by WirePlumber 0.5 (journal warning) | deleted (copy in backup) |
| `~/.config/pipewire/force-hdmi.sh` | pointed to HDMI 2 profile, monitor is on HDMI 3 | moved to backup |
| `~/.config/pipewire/pipewire.conf` (full copy, July) | full copies conflict with Debian updates | moved to backup as `pipewire.conf.full-copy`, replaced by `config/pipewire/pipewire.conf.d/10-rates.conf` |
| `~/.config/pipewire/pipewire.conf.d/hd650-classical.conf.disabled` | inactive filter-chain EQ for HD650 | kept for reference (see `docs/roadmap.md`) |

## 3. FiiO silent after restart — profile flipped to `iec958-stereo` (2026-09-25)

- **Symptom:** after a PipeWire restart/reboot no sound on PO or LO; stream reached the DAC (`hw_params` 44100 S32_LE).
- **Root cause:** WirePlumber selected the card profile `output:iec958-stereo` (digital) instead of `output:analog-stereo`.
- **Fix:** `pactl set-card-profile alsa_card.usb-FIIO_FiiO_K11_R2R-01 output:analog-stereo`, then made permanent (see #4).

## 4. HIFIMAN silent — same `iec958-stereo` flip; first pinning rule ineffective (2026-09-25)

- **Symptom:** HIFIMAN sink `...iec958-stereo`, graph not running (`QUANT 0`, `???`).
- **Root cause:** WirePlumber **auto-profile** + the stored choice in `~/.local/state/wireplumber/default-profile`
  override a plain `device.profile` rule.
- **Fix:** `config/wireplumber/wireplumber.conf.d/51-output-priorities.conf` — for both USB DACs:
  `device.profile = "output:analog-stereo"`, `api.acp.auto-profile = false`, `api.acp.auto-port = false`;
  `default-profile` state file moved to `backup-2026-09-25/`.
- **Verified:** both sinks `...analog-stereo`, descriptions "HIFIMAN EF499 (HD650)" / "FiiO K11 R2R (...)" loaded;
  **survived logout/login**. ⏳ Survive **reboot**: not yet verified.

## 5. EasyEffects appeared and took over (2026-09-25)

- `easyeffects_sink` (float32, 48000 Hz) appeared while testing; closed with `easyeffects -q`.
- Rule for later: in EasyEffects **Preferences → "Process all output streams" OFF**, output device fixed to the HIFIMAN.

## 6. EF499 stuck at 44.1 kHz while QBZ sent 96k/192k (2026-09-25)

- **Symptom:** `pactl list sink-inputs` → QBZ stream `float32le 2ch 192000Hz`; `/proc/asound/HIFIMANEF499/pcm0p/sub0/hw_params` → `rate: 44100`.
  The FiiO switched rates correctly at the same time.
- **Root cause:** the **GNOME Settings → Sound** panel's level meter was linked to the HIFIMAN monitor ports
  (`pw-link -l`: `...HIFIMAN...:monitor_FL |-> GNOME Settings:input_FL`). The DAC was never idle
  ("IDLE" instead of "SUSPENDED"), and PipeWire only changes a device's rate when nothing is using it.
- **Fix:** close GNOME Settings while listening.
  Optional rule proposed: `config-optional/pipewire/pipewire-pulse.conf.d/20-gnome-settings-passive.conf` — **not confirmed applied or tested.**
- **Verified:** with Settings closed → HIFIMAN SUSPENDED when idle; QBZ Ashkenazy (24/192) → `rate: 192000`;
  next CD-quality album → `rate: 44100`. Rate follows the album.
- Note: the Ashkenazy *Rachmaninov 24 Preludes* album is served by Qobuz as **24-bit/192 kHz**
  (QBZ badge + log `sampling_rate=Some(192000)`); the "96 kHz" in its review text refers to an older remaster. QBZ does **not** upsample.

## 7. QBZ exclusive / hw mode does not engage (2026-09-25) — OPEN

See `docs/qbz.md` for the full log excerpt. Summary:
- QBZ log: `plugin: Some(Pcm)`, `exclusive: false` → the **ALSA plugin = hw** and **Exclusive** settings were not active.
- `front:CARD=HIFIMANEF499,DEV=0 not resolvable by ALSA` inside the Flatpak; fallback `hw:CARD=...` via CPAL failed;
  QBZ then **falls back to legacy output through PipeWire** (`owner_pid` of the DAC = PipeWire).
- Flatpak permission fixed: `org.freedesktop.ReserveDevice1.*=own`.
- Next step: set ALSA plugin **hw** + Exclusive **on** + Reserve **on**, screenshot, restart QBZ, verify.

## Minor

- `xdg-desktop-portal: Caught PipeWire error: connection error` — only after PipeWire restarts; harmless.
- UGREEN camera mic uses profile `iec958-stereo` input and dropped off USB twice — unrelated, not fixed.
- Two stray files `~/QBZ` and `~/Askenazy` were created by a typo (`echo > ...`) — safe to delete.
