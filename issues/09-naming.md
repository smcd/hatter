# 9. Naming and identity

**Do this first.** Cheap, blocks every public artifact (#10, #11), and the name is load-bearing.

## The problem with "muxmux"

The `*mux` namespace is saturated: tmux, cmux, wmux, dmux, smug, twm, workmux,
mx.sh, intmux. "muxmux" reads as parody in that lineup, is hard to say out loud,
and is close to unsearchable. It also describes the *mechanism* (multiplexing),
which is the least interesting thing about the project.

The **hat** is the differentiator. No one else has it. Lead with it.

## Candidates

| Name | Binary | Pitch | Notes |
|---|---|---|---|
| **Hatrack** | `hatrack` / `hr` | "Where you hang your hats." | **Recommended.** Clear metaphor, memorable, says *storage of many identities*, escapes the `*mux` swamp entirely. Reads well as a product. |
| **Haberdash** | `hab` | "Outfitter for your shells." | Distinctive, fun, very available. Slightly obscure; needs the joke explained once. |
| **Hatbox** | `hatbox` | "Your workspace, packed and portable." | Leans on the *portable config* property rather than the multi-identity one. Good if the pitch is backup/restore. |
| **Hatstand** | `hatstand` | UK variant of Hatrack. | Also British slang for "eccentric". Might be a feature. |
| **Millinery** | `mill` | The hat-making trade. | Elegant, but nobody knows the word. `mill` collides with build tooling. |
| **Peg** | `peg` | "A peg for every hat." | Short and typeable, but generic and heavily overloaded. |
| **Tophat** | `tophat` | — | Too twee, and `tophat` is taken in a few ecosystems. |

## Decision: **hatter** (2026-09-06)

Agent noun, which is the right shape for a CLI — `docker`, `cargo`, `helm`,
`porter`. The tool is the hatter; hats are what it keeps. `hatrack` names a
place, which suits the config file but not the program.

It also fixes the repetition problem: `hatrack hat list` reads badly, whereas the
subcommand can go plural under `hatter`:

```
hatter hats                     # list
hatter hats status
hatter wear dev                 # attach / focus
hatter dev-atlas --group "Atlas"
hatter restore
```

Considered and rejected: making the binary itself `hat` — too close to `cat`,
and it collides with the concept noun ("run hat hat list").

### Availability, checked 2026-09-06

| Where | Status |
|---|---|
| Homebrew | **free** — this is the registry that matters for a Go binary |
| GitHub | three unrelated `hatter` repos exist; repo names are per-owner, so ours is fine |
| crates.io | taken — HTML templating lang by xvxx, dormant since Oct 2020. Irrelevant unless we ship Rust. |
| npm | taken — a CMS. Irrelevant unless we ship a Node component. |
| `hatter.dev` | taken and live (Vercel) |
| `hatter.io` | parked on Afternic, i.e. broker-priced |
| `hatter.sh` | registered Aug 2025 (Namecheap), parked. **Registry expiry 2027-08-21, status `autoRenewPeriod`** — mid auto-renewal. If the owner does not pay it can still be dropped, then redemption, then possibly available ~Nov 2026. |

`.sh` is close to perfect for a shell tool, so `hatter.sh` is worth waiting for.

### The one argument against

"Mad as a hatter" is mercury poisoning, and both squatters lean into the joke —
the crates.io crate calls itself *"positively mad"*, the npm package jokes about
*"sniffes mercury"*. For a tool whose pitch is **recovering cleanly from
disaster**, "mad" is a mild tension, and we would be the third project to make
the same gag. Judged not disqualifying: most people read Alice and whimsy.

## Remaining tasks

- [x] Pick the name — **hatter**
- [x] Check registry availability
- [x] Watch `hatter.sh` for a drop — cron every 6h on a shell box,
      `~/.local/bin/domain-watch`, emails on availability or status change
- [ ] Decide interim domain: `gethatter.dev`, `hatter.tools`, or no domain until
      it matters (GitHub Pages URL is fine to start)
- [ ] One-line pitch. Draft: *"Your multi-machine workspace as one portable config file."*
      Explicitly **not** "a tmux session manager" — saturated, will be ignored.
- [ ] Rename in code, config path (`~/.config/hatter/`), tmux managed-block
      markers (the stripper already handles legacy markers, so it is a
      re-provision away), and the `hatter` binary itself

## Scope

- [ ] Pick the name
- [ ] Check crates.io / npm / Homebrew / GitHub org availability
- [ ] Register the domain (see #11)
- [ ] One-line pitch. Draft: *"Your multi-machine workspace as one portable config file."*
      Explicitly **not** "a tmux session manager" — that market is saturated and
      the pitch will be ignored.
- [ ] Rename in code, config path (`~/.config/<name>/`), and tmux managed-block
      markers — note the block-stripper already handles legacy markers, so a
      rename is a re-provision away
