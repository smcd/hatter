# 2. Define the client adapter interface

**This is the keystone issue.** Everything else is downstream of whether this seam is real.

## Why

Right now cmux is hardcoded throughout. The pitch — "set up once, independent of
any client" — is only true if a second client can be dropped in without touching
the core.

## Approach

Extract the interface **in bash first**, before any rewrite. Cheap, and it
answers the question that matters: is there actually a clean seam here, or is
hatter just a cmux script wearing a hat?

## The surface

Every cmux call currently made, grouped by what it is really asking for:

| Capability | Today (cmux) | Notes |
|---|---|---|
| List client windows | `list-windows` | Must return stable ids |
| Open a window | `new-window` | Returns nothing useful; we diff before/after |
| Focus a window | `focus-window` | |
| List workspaces in a window | `workspace list --window` | |
| Create/find a group | `workspace-group create/list` | **Optional capability** |
| Add workspace to group | `workspace-group add` | Optional |
| Style a group | `set-color`, `set-icon`, `pin`, `collapse` | Optional, cosmetic |
| Mirror a host's tmux | `ssh-tmux <dest>` | **The hard one** |
| Rename a workspace | `rename-workspace` | Propagates to tmux |
| Close a workspace | `close-workspace` | |

## Capability negotiation

Adapters must declare what they support, and the core must degrade honestly
rather than pretending:

- `CanMirrorTmux` — if false, fall back to one pane per session running
  `ssh -t <dest> 'tmux new-session -A -s <name>'`
- `CanGroup` — if false, flatten groups into a naming convention on tabs/tabs titles
- `CanStyle` — if false, ignore colour/icon/pin/collapse silently

## Where the seam actually is

Measured 2026-09-10: 19 direct `cmux` calls, funnelling through twelve
functions. That list *is* the interface, and it is small enough to extract in
an afternoon:

    cmux_json  window_ids  have_cmux
    ensure_hat_window  find_hat_window  mirror_hat
    workspace_ref_by_title  wait_for_workspace  discard_stray_workspace
    ensure_cmux_group  apply_group_style

Everything else - config, ssh, tmux, credentials, autosave, the rack - never
touches a client.

Half of the headless case (#6) already exists: cmux is now required by the
commands that drive it rather than by the script, so `provision`, `creds`,
`backup`, `autosave`, `tab` and `hat` run on a client with no cmux at all.

## Acceptance

- [ ] Interface documented with the capability matrix above
- [ ] cmux adapter (#3) implements it with no core changes
- [ ] WezTerm adapter (#4) implements it with no core changes

**Kill criterion:** if #4 cannot be built without reaching back into the core,
the abstraction is fake. Say so publicly and keep hatter as a personal cmux tool.
