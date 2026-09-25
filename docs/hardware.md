# Hardware and software (facts as of 2026-09-25)

Card **numbers** can change between boots — always refer to cards by **name**
(`HIFIMANEF499`, `R2R`, `Generic_1`), never by number.

## Computer

| Item | Value | Source |
|---|---|---|
| Machine | Beelink SER 9 (AMD) | user |
| OS | Debian GNU/Linux 13 (trixie) | `/etc/os-release` |
| Kernel | 6.12.107+deb13-amd64 | `uname -r` |
| Sound server | PipeWire 1.4.2 (pulse compatibility) | `pactl info` |
| Session manager | WirePlumber **0.5.8** (Lua configs not supported) | `wireplumber --version` (snapshot 2026-09-25_142015) |
| EasyEffects | 7.2.3, native Debian package (`/usr/bin/easyeffects`) | `easyeffects --version` |
| QBZ | 2.1.2, Flatpak `com.blitzfc.qbz`, system install, flathub | `flatpak list` |
| Desktop | GNOME (Wayland) | screenshots |

## Sound cards (`/proc/asound/cards`)

| Name | Device | Notes |
|---|---|---|
| `POROSVOC` | USB 4-mic array | input only |
| `Generic` | AMD HDMI/DP audio (PCI 65:00.1) | monitor PHL 276E8V on "HDMI 2" → sink `hdmi-stereo-extra2` |
| `Generic_1` | Realtek **ALC897** analog (PCI 65:00.6) | 3.5 mm jacks; **disabled in WirePlumber on purpose** |
| `Camera` | UGREEN USB camera mic | input only; USB dropped twice on 2026-09-25 (unrelated) |
| `R2R` | **FiiO K11 R2R** — USB `2972:0099` | main DAC for ATH-R50x and TOMATE |
| `HIFIMANEF499` | **HIFIMAN EF499** — USB `2fc6:f043` (Comtrue), serial SXW230918 | DAC/amp for HD650 |

## HIFIMAN EF499

- USB playback formats (from `/proc/asound/HIFIMANEF499/stream0`): **S16_LE, S24_3LE, S32_LE, DSD_U32_BE (native DSD)**
- USB rates: **44100, 48000, 88200, 96000, 176400, 192000**
- Headphone outputs: **4-pin XLR balanced** (used for the HD650) and 6.35 mm single-ended. No 4.4 mm.
- Power: 4.35 W @ 32 Ω balanced, 1.28 W @ 32 Ω single-ended (manual).
- Front knob, 4 positions: **Hi impedance / Low impedance × NOS / OS**.
  - Current: **Hi impedance + OS** — "an amazing sound" (user, 2026-09-25). This is the reference for EQ work.
  - NOS vs OS by ear: open item (roadmap).
- Manual: https://www.manualslib.com/manual/3432563/Hifiman-Ef499.html

## FiiO K11 R2R

- USB formats include **DSD_U32_BE (native DSD)** (`grep -i dsd /proc/asound/R2R/stream0`, 2026-09-25).
- Outputs: **PO** (phone out: 6.35 mm, 4.4 mm balanced, 3.5 mm via adapter) and **LO SE** (RCA line out).
- In LO mode the volume is **fixed at 99** (line level) — volume is set on the device that follows (TOMATE).
- USB playback formats: **S16_LE, S24_3LE, S32_LE, DSD_U32_BE** (snapshot 2026-09-25_142015, `stream-fiio.txt`)
- USB rates: **44100, 48000, 88200, 96000, 176400, 192000, 352800, 384000** (higher than the EF499, which stops at 192000)
- Verified at 96 kHz and 192 kHz from QBZ (2026-09-25).

## Headphones and speakers

| Device | Impedance | Where |
|---|---|---|
| Sennheiser HD650 (open) | 300 Ω | EF499, 4-pin XLR balanced |
| Audio-Technica ATH-R50x (open) | 80 Ω | FiiO PO |
| TOMATE soundbar | — | FiiO LO SE (RCA → P2). Also has USB, coaxial, optical inputs (unused). Considered weak; may be replaced. |

## Cables

- **RCA (red/white) → P2**: FiiO LO → TOMATE — works, both channels.
- Old **P2 ↔ P2** cable (SER 9 jack → TOMATE): only the left channel was heard — cable **suspected** faulty (not proven; phone test not done).
- Coaxial (yellow) cable available; FiiO has coax out; tested once by the user and worked. Not used.
