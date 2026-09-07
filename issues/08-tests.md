# 8. Test suite and reliability

## Why

Four real bugs in one day of use, all silent. Anything with `restore` semantics
that other people trust needs tests before it needs features.

## Layers

**Unit** — config migration, hat/prefix resolution, group resolution order
(`--group` → recorded → hat default → first existing → prompt), session naming.

**Adapter contract tests** — one suite every adapter must pass, parameterised by
declared capabilities. This is what stops #4 and #5 drifting.

**Integration against real tmux** — spin a local `tmux -L test` server; assert
`restore` recreates sessions, windows and cwds. No client needed.

**Regression tests for the four known bugs:**
- [ ] unknown prefix + `--group` on a new group → clear error, not silent exit 1
- [ ] duplicate group name in a second window → sync does not clobber the real record
- [ ] one unreachable host → restore continues and reports, leaves no empty window
- [ ] freshly opened window → placeholder workspace is cleaned up

**Provision self-test** — already implemented and worth keeping as the model:
`provision` creates a throwaway session, exits its shell, and asserts a working
prompt comes back. It caught a race that `show-options` reported as fine.

## Acceptance

CI green on macOS and Linux; the tmux integration suite runs without a GUI.
