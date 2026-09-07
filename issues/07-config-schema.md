# 7. Config schema v1 and migration policy

## Why

The config has already been through three schema versions in one day
(`groups[].host` → named logins → `hats`). Once it is public, that stops being
free.

## Known problems to fix before v1

- **Groups are keyed by name globally.** Two hats cannot both have a group called
  the same name. This already forced a rename workaround in practice. Groups should be
  keyed by `(hat, name)` or carry an opaque id.
- **`remote_dir` stores the literal string `$HOME`**, expanded remotely. Works,
  but is untyped and surprising. Decide: literal path, or explicit `~` semantics.
- **No schema version negotiation** — an older binary reading a newer config
  should refuse clearly rather than silently mangling it.

## Scope

- [ ] JSON Schema published alongside the binary
- [ ] `hats[].default_group` (already added) formalised
- [ ] Forward-compat rule: unknown keys preserved on write, never dropped
- [ ] `migrate` as an explicit command, not a side effect of every invocation
- [ ] Document that the config holds **no secrets** — hostnames and usernames
      only — but does map infrastructure, so a private remote is advised

## Acceptance

A v1 config written by the Go binary is readable by the bash version's successor
and vice versa for at least one release.
