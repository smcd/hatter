# 5. wmux adapter — native Windows

**Depends on:** #2, #4. Lower priority than WezTerm.

## Context

[wmux](https://www.wmux.app/en) is the closest thing to a native Windows cmux:
Windows 10/11 + macOS, ConPTY terminals, tmux-style splits, sessions that survive
reboot, a `wmux` CLI (`send`, `read-screen`, `list-panes`) and MCP tools
(`pane_list`, `pane_split`, `surface_new`, `workspace_list`).

## Why it is not the first Windows target

- **No remote tmux mirroring.** It mirrors another machine's `wmux web` into its
  sidebar — a different model from `cmux ssh-tmux`. Wrong shape for hats.
- **No workspace-grouping concept** to map groups onto.
- Ecosystem is unsettled: two GitHub repos both claim to be "the original", and
  a widely-cited "vMux" could not be verified as a real project. Treat with care.

## Acceptance

Hats and workspaces work on Windows with `CanMirrorTmux: false`, `CanGroup: false`.
Reassess if wmux ships remote tmux attach.
