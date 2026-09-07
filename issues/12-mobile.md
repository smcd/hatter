# 12. Mobile mode

**Depends on:** #6 (headless adapter). Mostly already true — this is about naming and polishing it.

## The insight

Because state lives in remote tmux and the client is a projection, mobile is
largely **not building anything**. Any SSH client on a phone — Blink Shell,
Termius, a-Shell — can already reach a hat and attach. The hard part (getting the
right sessions running on the right hosts) is the server-side half, which already
works.

This is a genuine architectural advantage over the desktop-app-shaped agent
orchestrators, and worth saying out loud in the docs.

## Phase 1 — make the existing story explicit (cheap)

- [ ] `<name> attach <hat> [workspace]` → `ssh -t <dest> 'tmux new-session -A -s <name>'`
- [ ] `<name> list --plain` that reads well on a narrow screen
- [ ] Docs page: run the binary *on a hat* (it is a static binary; put it on the
      server) and drive everything from a phone over one ssh session
- [ ] Verify tmux mouse mode and the `default-command` shell loop behave under
      iOS/Android SSH clients

## Phase 2 — only if there is demand

- [ ] Evaluate whether a native app adds anything over Blink/Termius plus a
      good tmux config. Suspect it does not.
- [ ] If anything, a read-only status view: which hats are up, which sessions
      are running, unread agent notifications. That is a different, smaller product.

## Non-goal

Reimplementing a terminal emulator for mobile. That is a solved problem and not
our advantage.
