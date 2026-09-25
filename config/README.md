# config/

Exact copies of the files that are **live** on the SER 9 (paths relative to `~/.config/`).
`scripts/snapshot.sh` writes `config-diff.txt` showing any difference between this folder and the machine.

| Repo path | Live path | Purpose |
|---|---|---|
| `pipewire/pipewire.conf.d/10-rates.conf` | `~/.config/pipewire/pipewire.conf.d/10-rates.conf` | allowed sample rates |
| `wireplumber/wireplumber.conf.d/51-output-priorities.conf` | same under `~/.config/` | analog profiles pinned, priorities, names |
| `wireplumber/wireplumber.conf.d/disable-analog.conf` | same under `~/.config/` | onboard ALC897 disabled |

Not in the repo on purpose: `~/.config/pipewire/pipewire.conf.d/hd650-classical.conf.disabled`
(inactive; a copy lives in `backup-2026-09-25/`).
