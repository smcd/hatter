# 10. Open source on GitHub

**Depends on:** #9 (name), and ideally #4 (so the client-agnostic claim is true on day one).

## Do not publish before the adapter proof

Publishing while cmux is the only adapter invites exactly one reaction: "so it's
a cmux script". The WezTerm adapter is what makes the README's claim defensible.

## Scope

- [ ] Repo under a personal or org account, MIT or Apache-2.0
- [ ] README that leads with **hats** and the rebuild-from-config property, with
      an asciinema of a full `restore` after killing every session
- [ ] `CONTRIBUTING.md` with the adapter contract (#2) front and centre —
      new adapters are the contribution we actually want
- [ ] CI: build + test on macOS, Linux, Windows
- [ ] Releases: signed static binaries per platform, Homebrew tap, `winget`/`scoop`
- [ ] `SECURITY.md` — the config maps infrastructure; say plainly that it holds no
      secrets but should live in a private remote
- [ ] Issue templates, starting with "new client adapter"

## Sanitisation before first push

The config and docs grew up around one person's real hosts and usernames.
Every example now uses `example.com`. **Re-audit every example, test
fixture and screenshot** before the repo goes public. Use `example.com` hosts.

## Acceptance

A stranger can install a binary, write a five-line config, and get a working
two-hat setup without reading the source.
