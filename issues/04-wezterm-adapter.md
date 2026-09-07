# 4. WezTerm adapter — the portability proof

**Depends on:** #2. **This is the issue that decides whether the project is real.**

## Why WezTerm over the alternatives

| Candidate | Windows | Scriptable | Remote | Verdict |
|---|---|---|---|---|
| **WezTerm** | native | `wezterm cli` (spawn, list, split-pane, set-tab-title) | SSH domains + built-in mux | **best target** |
| wmux | native (10/11) + macOS | `wmux` CLI, MCP tools | mirrors its own `wmux web`, **not remote tmux** | see #5 |
| Zellij | none (WSL only) | good | — | out |
| Windows Terminal + WSL | native | weak | — | fallback only |
| Tabby | native | plugin API | SSH profiles | maybe later |

WezTerm is the only option that is genuinely cross-platform *and* properly
scriptable *and* has a remote story. It also gets us Linux for free.

## Capability profile

- `CanMirrorTmux: false` — no control-mode mirror. Use the documented fallback:
  one tab per session running `ssh -t <dest> 'tmux new-session -A -s <name>'`.
  Persistence still comes from tmux, so the core property holds.
- `CanGroup: false` (initially) — WezTerm has tabs and windows, no group concept.
  Map hat → window, workspace → tab, and encode the group in the tab title.
  Revisit whether WezTerm workspaces can carry groups.
- `CanStyle: partial` — tab colours via config.

## Open questions

- [ ] Do WezTerm SSH domains add anything over plain `ssh` + tmux here, or are
      they a competing persistence model we should stay out of?
- [ ] Can `wezterm cli` address a specific window reliably, or does it have the
      same "current window" ambiguity cmux has?

## Acceptance

Full `restore` of the five-hat config on a machine with WezTerm and no cmux,
with **zero changes to the core**.
