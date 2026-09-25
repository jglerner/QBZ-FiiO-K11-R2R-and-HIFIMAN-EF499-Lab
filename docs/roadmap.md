# Roadmap

## Listener profile (drives every decision)

- Classical music; **quality over volume**; absolute fidelity.
- Decades of live concerts worldwide — the ear is the final judge.
- Open headphones on purpose: to feel *present in the hall*.
- Venues the user knows first-hand: Carnegie Hall, Royal Albert Hall, LSO (Barbican), the Met,
  La Scala, La Fenice (Venice — knew it before and after the 1996 fire), a theatre in Prague
  (Estates Theatre or Rudolfinum — to confirm), a ~50-seat room in Salzburg, Prokofiev's home (recital on his piano).
- Likes to experiment and read; wants 1–3 good presets to tune further, not a finished black box.

## Step 0 — Close the open items

- [ ] QBZ exclusive/hw mode (`docs/qbz.md`): plugin **hw**, Exclusive **on**, Reserve **on**, verify owner_pid.
- [ ] Confirm profiles survive a **reboot** (`pactl list short sinks` → both `analog-stereo`).
- [ ] Decide on `config-optional/.../20-gnome-settings-passive.conf` (not applied yet; test, then keep or delete).
- [x] Capture FiiO rate list — 44.1k…384k, S16/S24_3LE/S32/DSD (snapshot 2026-09-25_142015).
- [ ] Review the existing EasyEffects presets/IRs (findings #9): which HD650 preset was used, what to keep.

## Step 1 — EasyEffects "HD650 – Base"

Signal: QBZ (shared mode, output **Easy Effects Sink**) → EasyEffects → **HIFIMAN EF499**. Pure path stays available.

1. EasyEffects Preferences: **Process all output streams = OFF**; PipeWire tab → Output: HIFIMAN EF499 (not "default").
2. Equalizer → *Import APO preset* → `eq/HD650-AutoEQ-oratory1990.txt` (10 filters, preamp −6.1 dB).
3. Crossfeed after the EQ: start at default **700 Hz / 4.5 dB** (then try Cmoy / Jmeier).
4. Save preset **`HD650 - Base`**.
5. Compare with Pure at **equal loudness** (Base is ~6 dB quieter — compensate on the EF499 knob).

AutoEQ vs the user's old curve (`backup-2026-09-25/pipewire/pipewire.conf.d/hd650-classical.conf.disabled`):

| | Bass | ~120–150 Hz | ~3.2 kHz | Treble/air | Preamp |
|---|---|---|---|---|---|
| Old curve | shelf 80 Hz +3.5 | 150 Hz −2.0 | −1.5 | shelf 9 kHz +4.0 | −3.5 |
| AutoEQ (oratory1990) | shelf 105 Hz +6.4 | 118 Hz −3.1 | −1.7 | peak 8.8 kHz +5.1 | −6.1 |

The old curve was already a gentler version of the measured correction.

## Step 2 — Hall presets (convolution)

Principle: recordings already contain their hall — adding a second one stacks rooms. So:
Base (EQ + crossfeed) for most listening; hall convolution for dry / close-miked recordings or chosen atmosphere,
with adjustable **wet/dry**. IRs go in `~/.config/easyeffects/irs/`; sources and licenses recorded in `irs/README.md` here.

| Preset | Character | User's references | Target RT60 |
|---|---|---|---|
| **Chamber** | intimate, close, clear (solo piano → string trio) | Salzburg ~50 seats, Prokofiev's home | ~0.8–1.3 s |
| **Opera house** | horseshoe, relatively dry, warm | La Scala, La Fenice, Estates Theatre, the Met | ~1.2–1.6 s |
| **Concert hall** | large, enveloping | Carnegie Hall, Royal Albert Hall, Rudolfinum | ~1.8–2.5 s |

Candidate IR source: OpenAIR (University of York) and other licensed free libraries. IRs of the exact venues are
unlikely to be public — choose rooms of the same character and judge by ear.

## Later

- NOS vs OS on the EF499, by ear, same tracks.
- FiiO + ATH-R50x: optional light preset (AutoEQ ATH-R50x + crossfeed).
- A one-command switch Pure ↔ EasyEffects (QBZ output device + exclusive toggle) if switching becomes tedious.
- Replace the TOMATE (user plans to).
