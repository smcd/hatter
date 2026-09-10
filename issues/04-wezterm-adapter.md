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

## Verified CLI surface

Checked against the WezTerm docs, 2026-09-10:

    wezterm cli list --format json
      -> window_id, tab_id, pane_id, workspace, title, cwd

    wezterm cli spawn --new-window --workspace <name> -- <cmd>   # prints new pane id
    wezterm cli spawn --window-id <n> -- <cmd>                   # a tab in that window
    wezterm cli spawn --cwd <path> -- <cmd>
    wezterm cli set-tab-title --tab-id <n> "<title>"
    wezterm cli activate-tab --tab-id <n>

This is the part that matters: **WezTerm can be read back**, which is what
`sync` needs. It is the only Windows candidate that can. Windows Terminal can
be driven but not queried, so `sync` is impossible there and `restore` becomes
fire-and-forget - which is why it stays a fallback.

## Open questions, answered

- **Can `wezterm cli` address a specific window reliably?** Yes. `--window-id`
  is explicit and `--new-window` returns the pane id it made, so a window is
  never inferred from what happens to be focused. Note this is exactly the
  class of bug that bit `bye`: a default target is not the calling context.
- **Do WezTerm SSH domains add anything?** Stay out of them. They are a
  competing persistence model, and persistence is tmux's job here. Plain
  `ssh -t <dest> tmux new-session -A -s <name>` keeps one story.
- **CanGroup may be true after all.** `wezterm cli list` reports a `workspace`
  name per pane, and `spawn --new-window --workspace <name>` sets it, so
  WezTerm's named workspaces are a real grouping primitive - not the tab-title
  encoding assumed above. Try that first; fall back to title encoding only if
  a workspace cannot span the tabs we need.
- **Control mode is still out.** wezterm/wezterm#336 is open; there is partial
  work (including a Windows crash fix) but nothing to build on.
  `CanMirrorTmux: false` stands.

## Mapping

| hatter | cmux | WezTerm |
|---|---|---|
| hat | window | window |
| group | workspace-group | named workspace (verify), else tab-title prefix |
| workspace | mirrored tmux session | tab running `ssh -t <dest> tmux new-session -A -s <name>` |
| tab | mirrored tmux window | tmux's own window inside that tab |

The loss is real and worth stating plainly: a hat's tmux windows stay tmux
windows. You switch them with the tmux prefix, not by clicking a tab.

## Acceptance

Full `restore` of the five-hat config on a machine with WezTerm and no cmux,
with **zero changes to the core**.
