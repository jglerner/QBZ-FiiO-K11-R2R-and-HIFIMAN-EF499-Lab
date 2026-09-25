# Linux Sound — SER 9 listening setup

Repository: `jglerner/QBZ-Fiio-K2-R2R-amd-HIFIMAN-E499-Lab` — local copy on the SER 9: `~/Programs/Linux Sound`

Goal: **quality over volume** — classical music, absolute fidelity, and (later) the
sensation of being in a real concert hall on open headphones.

This repository is the single source of truth. Every statement in `docs/` is either
**verified** (with date and the command that proved it) or explicitly marked
**unverified / open**. Machine facts are captured by `scripts/snapshot.sh` into `state/`.

## Start of every session

```bash
cd ~/Programs/"Linux Sound"
git pull
./scripts/snapshot.sh          # writes state/<date_time>/ with the machine's real state
git add state && git commit -m "snapshot" && git push
```

Then tell Claude: *"read the latest snapshot in state/"*. No guessing, no re-checking by hand.

## The system at a glance

| Output | Role | Connection | Processing |
|---|---|---|---|
| **HIFIMAN EF499 → Sennheiser HD650** (300 Ω) | Serious listening | USB; 4-pin XLR balanced; knob **Hi impedance + OS** | Pure (bit-perfect). Later: EasyEffects presets |
| **FiiO K11 R2R → Audio-Technica ATH-R50x** (80 Ω) | Music while working | USB; **PO** (phone out) | Pure |
| **FiiO K11 R2R → TOMATE soundbar** | When people are around | FiiO **LO SE** (RCA) → P2 on TOMATE | Pure; volume on the TOMATE (LO is fixed level) |
| Onboard Realtek ALC897 (3.5 mm) | Not used | — | Disabled on purpose |
| Monitor HDMI (PHL 276E8V) | Not used for music | HDMI | — |

Player: **QBZ** (Qobuz client, Flatpak `com.blitzfc.qbz`), streaming quality **Hi-Res+**.

## Current status (2026-09-25)

| Item | Status |
|---|---|
| TOMATE plays (via FiiO LO) | ✅ verified |
| Both USB DACs on `analog-stereo` profile (not `iec958`) | ✅ verified, survives logout — ⏳ reboot not yet verified |
| QBZ → EF499 at the album's native rate (192k and 44.1k seen) | ✅ verified (through PipeWire, no resampling) |
| QBZ **exclusive / hw** mode (bypass PipeWire) | ❌ not working yet — see `docs/qbz.md` |
| EasyEffects "HD650 – Base" (AutoEQ + crossfeed) | ⏳ not started |
| Hall presets (Chamber / Opera house / Concert hall) | ⏳ not started |

## Rules that keep it bit-perfect

1. **QBZ volume 100 %** and **system volume of the DAC 100 %** — use the DAC knob.
2. **Close GNOME Settings (Sound panel)** while listening — its level meter locks the DAC's sample rate (see `docs/findings.md` #6).
3. Quit QBZ from its tray/menu (closing the window leaves it running). From a terminal: `flatpak kill com.blitzfc.qbz`.
4. ⚠️ Before switching the FiiO **LO → PO**, turn the volume **down**.

## Layout

| Path | Content |
|---|---|
| `docs/hardware.md` | Devices, USB IDs, supported rates/formats, knobs |
| `docs/findings.md` | Every problem found, root cause, fix, verification |
| `docs/qbz.md` | QBZ settings, logs, exclusive-mode investigation |
| `docs/roadmap.md` | Next steps: exclusive mode, EasyEffects base, hall presets |
| `docs/verify.md` | Copy-paste commands to check each fact |
| `config/` | Exact copies of the live config files in `~/.config` |
| `config-optional/` | Tried or proposed, **not confirmed active** |
| `eq/` | Headphone EQ files (AutoEQ) |
| `scripts/snapshot.sh` | Captures machine state into `state/` |
| `state/` | Snapshots (facts) — committed |
| `backup-2026-09-25/` | Configs as they were before this project (added from the SER 9) |
