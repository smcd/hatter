# 13. Server provisioning as a first-class concern

## Why

`provision` is currently the most valuable and least designed part of the tool.
It is what makes a hat trustworthy, and it already encodes two hard-won lessons.

## What it does today

Writes a managed block into the remote `~/.tmux.conf`:

- tpm + tmux-resurrect + tmux-continuum, autosave every 15 min, restore on server start
- `set -g default-command 'while true; do "$SHELL" -l; sleep 0.3; done'` — every
  pane's login shell in a loop, so `exit` and stray ctrl-D hand back a fresh
  prompt instead of destroying the tab

Then self-tests by exiting a shell in a throwaway session and asserting a usable
prompt comes back.

## The lesson worth preserving

The obvious implementation — `remain-on-exit on` + `set-hook -g pane-died
'respawn-pane -k'` — **is racy**. Measured ~2/3 success on a busy server; the
deferred `run-shell -b` variant was worse at 1/6. `tmux show-hooks -g` will
happily report a hook that never fires. The shell loop is hook-free and measured
6/6, then 5/5 on re-test.

**This is why the self-test exists and must stay.** Introspection lied; only
behaviour told the truth.

## Scope

- [ ] Keep the managed-block markers and the legacy-marker stripper (renames are
      a re-provision away)
- [ ] Make the block a versioned asset so `provision` can report "your server is
      running block v3, current is v4"
- [ ] Support shells other than bash/zsh (fish's `$SHELL -l` loop needs checking)
- [ ] `provision --dry-run` printing the diff to `~/.tmux.conf`
- [ ] `doctor` command: for each hat, is it reachable, is the block current, does
      the self-test pass
- [ ] Decide whether tpm is a hard dependency or whether resurrect/continuum can
      be vendored — one less thing to fail on a fresh box
