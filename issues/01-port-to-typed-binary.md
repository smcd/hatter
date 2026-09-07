# 1. Port from bash to a single typed binary

**Blocked by:** #2, #4 — do not start until the adapter interface has survived two implementations.

## Why

The bash version is ~1000 lines of `jq` pipelines and command substitution. In one
day of real use it produced four distinct failure modes, all from the same root
cause: functions that fall off the end with a non-zero status, silently killing
the script under `set -e`.

- `session_hat` returned 1 for an unknown prefix → `hatter <name> --group X` exited 1 with no output
- `workspace_ref_by_title` had the same hazard in its `for` loop
- `cmd_sync` scanned all windows, so a duplicate group name in another window wiped a real record
- `cmd_restore` aborted the whole run on the first unreachable host

None of these were hard to fix. All of them were invisible until they bit.

## Language

**Go.** Single static binary matters more than anything else here — Windows
support is a stated goal, and "download one file" beats any runtime dependency.
Rust is defensible; Go's advantage is that the whole program is process
orchestration and JSON, which is exactly Go's sweet spot.

Explicitly rejected: Python (runtime dependency, packaging on Windows),
TypeScript/Node (same), staying in bash.

## Scope

- [ ] Config load/save with a versioned schema (see #7)
- [ ] Hat / group / workspace / tab model as real types
- [ ] SSH transport with connection reuse (`ControlMaster`) instead of one process per call
- [ ] Adapter interface (#2) with the cmux adapter (#3) as first implementation
- [ ] All current commands: `new`, `tab`, `rename`, `hat`, `group`, `list`, `sync`, `restore`, `provision`, `backup`
- [ ] Structured errors — no silent exits, ever

## Non-goals

- Rewriting `provision`'s remote shell script. It is a shell script that belongs
  on the server; embed it as a string asset.
- A TUI. The CLI plus the client's own UI is the product.

## Acceptance

Feature parity with the bash version, verified by running both against the same
five hats and diffing `list` output and the resulting cmux layout.
