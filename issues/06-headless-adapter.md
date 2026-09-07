# 6. Headless / tmux-only adapter

**Depends on:** #2

## Why

The lowest common denominator, and quietly the most important one for
credibility: it proves the core does not need a GUI at all.

With no client, `restore` should still reconstruct every tmux session and window
on every reachable host. That is the half of the state that actually matters —
the client is a projection.

## Scope

- [ ] `CanMirrorTmux: false`, `CanGroup: false`, `CanStyle: false`
- [ ] `restore` recreates all server-side state and reports what it did
- [ ] `attach <hat> [workspace]` execs `ssh -t <dest> 'tmux new-session -A -s <name>'`
- [ ] Usable over a plain SSH session from anything, including a phone (#12)

## Acceptance

`restore` then `attach` from a bare terminal with no desktop client installed.
