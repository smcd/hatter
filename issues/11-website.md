# 11. Dedicated website and docs

**Depends on:** #9, #10

## Scope

- [ ] Domain, matching the name from #9 (`hatrack.dev` if that lands)
- [ ] Static site — no framework needed; the docs are the product
- [ ] Landing page: the hat diagram, one asciinema of `restore` rebuilding
      everything after a simulated total loss, install one-liner
- [ ] Docs: concepts (hat/group/workspace/tab), CLI reference, **adapter authoring
      guide**, server provisioning, config schema (#7)
- [ ] A "why not X" page — tmuxp, tmuxinator, sesh, workmux, cmux alone. Be
      generous and accurate; most visitors will arrive already using one of them
- [ ] Config-backup guide: plain git to a remote you own, no vendor. The
      bootstrap secret is your ssh key, not the repo

## Tone

The competition is a wall of AI-terminal marketing. Do the opposite: plain,
technical, honest about what it does not do. Lead with the failure modes it
survives, not the buzzwords.
