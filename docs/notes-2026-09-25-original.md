# Linux Sound (SER 9, Debian 13, PipeWire 1.4 / WirePlumber 0.5)

## Outputs
| Device | Use | Connection |
|---|---|---|
| FiiO K11 R2R | Main DAC. PO = ATH-R50x (80 ohm), LO SE = TOMATE soundbar | USB; LO RCA -> P2 on TOMATE |
| HIFIMAN EF499 | HD650 (300 ohm) | USB |
| Onboard Realtek ALC897 | Disabled on purpose | - |

Safety: lower the volume before switching FiiO LO -> PO.

## Config files
- ~/.config/pipewire/pipewire.conf.d/10-rates.conf: allowed sample rates (bit-perfect)
- ~/.config/wireplumber/wireplumber.conf.d/51-output-priorities.conf: FiiO default
- ~/.config/wireplumber/wireplumber.conf.d/disable-analog.conf: onboard audio off
- backup-2026-09-25/: configs as they were before this project

## History
- 2026-09-25: TOMATE "not working" = onboard jack disabled + one-channel P2 cable.
  Moved the TOMATE to the FiiO line out. Cleaned up old Lua and HDMI files.
- 2026-09-25: FiiO profile had flipped to iec958 (silent). Pinned analog-stereo for both
  DACs in 51-output-priorities.conf. Verified QBZ 96k -> FiiO 96k with no resampling.
  Keep QBZ volume and system volume at 100%; FiiO LO is fixed level, TOMATE sets the volume.
- 2026-09-25: FiiO profile had flipped to iec958 (silent). Pinned analog-stereo for both
  DACs in 51-output-priorities.conf. Verified QBZ 96k -> FiiO 96k with no resampling.
  Keep QBZ volume and system volume at 100%; FiiO LO is fixed level, TOMATE sets the volume.
- 2026-09-25: HIFIMAN also flipped to iec958. Fixed with api.acp.auto-profile=false +
  device.profile=analog-stereo for both DACs; old default-profile state moved to backup.
  EF499: 4-pin XLR balanced, knob = Hi impedance + OS (reference for EQ work).
  Pure path (QBZ -> EF499, no EasyEffects) = the reference sound.

## Next
- Step 1: EasyEffects "HD650 - Base" (AutoEQ oratory1990 in eq/ + crossfeed), compare vs Pure.
- Step 2: Chamber / Opera house / Concert hall presets (convolver IRs).
- Later: try NOS vs OS by ear; confirm profiles survive a reboot.
