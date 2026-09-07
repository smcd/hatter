# 3. cmux adapter (extract from current bash)

**Depends on:** #2

## Scope

Move every `cmux ...` invocation behind the adapter interface. Reference
implementation, and the only one with full capability support today.

## cmux behaviours the adapter must encode

Learned the hard way; these are non-obvious and must not be lost in the port:

- **`CMUX_WORKSPACE_ID` / `CMUX_SURFACE_ID` / `CMUX_TAB_ID` beat `focus-window`.**
  cmux terminals export them and the CLI treats them as the default target for
  any command without an explicit `--window`. A tool that drives windows other
  than its own **must unset them**, or groups get created in the calling window.
- **Short refs (`workspace:3`) are window-scoped and collide across windows.**
  Always `--id-format both` and use the UUID.
- **`cmux rename-window` renames the selected *workspace*, not the window.**
  cmux windows have no name at all; a window can only be identified by its contents.
- **Renaming a mirrored workspace renames the remote tmux session**, and vice
  versa. Titles stay in sync for free.
- **`cmux new-window` seeds a throwaway `~` workspace** that must be cleaned up
  once real content lands — and it is not titled `~` at the instant of creation.
- **`cmux close-window` does not close a window**; close its last workspace instead.
- **`cmux send --workspace ""` does not error** — it silently falls back to a
  default target. Always validate a selector before sending keystrokes.
- **`ssh-tmux` mirrors *all* of a host's sessions** into the current window, so
  one hat must map to exactly one `user@host`.

## Acceptance

Existing five-hat setup works identically through the adapter.
