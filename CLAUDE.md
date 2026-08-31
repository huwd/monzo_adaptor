# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MonzoAdaptor is a Ruby gem that wraps the [Monzo API](https://docs.monzo.com/). It follows the same pattern as [`wikidata_adaptor`](https://github.com/huwd/wikidata_adaptor): `MonzoAdaptor::RestApi` extends `ApiAdaptor::Base`, and each API resource (Accounts, Balance, Pots, Transactions, etc.) is a separate module included into it. Corresponding test helper modules in `lib/monzo_adaptor/test_helpers/` provide WebMock stubs for consumers of the gem.

It is a from-scratch rebuild that deliberately ports proven logic — the OAuth/SCA flow, resource field knowledge — from an earlier, dormant gem (`huwd/monzo_api`, 2023) rather than re-deriving it, while adopting `api_adaptor`'s HTTP/error-handling layer and `wikidata_adaptor`'s test conventions.

## No Monzo sandbox

There is no official Monzo sandbox or test environment — confirmed via `community.monzo.com` threads: "API sandbox for testing purposes" is an unfulfilled feature request, and the "API Playground" on developers.monzo.com is just an authenticated console against your **real** account, not a test double. Do not build tooling that assumes a sandbox exists.

Consequences:

- No integration test suite runs against a live Monzo account, ever (unlike `wikidata_adaptor`'s docker-compose Wikibase integration tests).
- Instead, default unit tests run offline against fixtures vendored from Monzo's own public docs source, [`github.com/monzo/docs`](https://github.com/monzo/docs) (Slate-format Markdown, one file per resource under `source/includes/`, each with real request/response examples).
- A separate, non-CI "contract" check refreshes and diffs those vendored fixtures against the live docs source, to catch drift. It never touches a real Monzo account.

## Commands

```bash
# Run all checks (specs + rubocop)
bundle exec rake

# Unit tests only
bundle exec rspec

# Single test file
bundle exec rspec spec/monzo_adaptor/rest_api/accounts_spec.rb

# Lint
bundle exec rubocop

# Refresh vendored Monzo docs fixtures from github.com/monzo/docs (manual only)
bin/refresh-monzo-docs

# Contract check: diff vendored fixtures against the live docs source
# (network access, excluded from the default suite and from CI)
CONTRACT=1 bundle exec rspec spec/contract
```

## Architecture

- **`lib/monzo_adaptor/rest_api.rb`** — Main client class, inherits `ApiAdaptor::Base`, includes all resource modules. Overrides `get_json`/`post_json`/etc. to translate Monzo's 403/429 responses into `MonzoAdaptor::InsufficientPermissionsError`/`MonzoAdaptor::RateLimitError`.
- **`lib/monzo_adaptor/rest_api/`** — One module per API resource (whoami, accounts, balance, pots, transactions, feed_items, attachments, receipts, webhooks). Methods return plain parsed Hashes/Arrays — not typed objects.
- **`lib/monzo_adaptor/oauth.rb`** — `MonzoAdaptor::OAuth`, a standalone client for the OAuth2 handshake (authorize URL, code exchange, refresh, logout). Deliberately **not** an `ApiAdaptor::Base` subclass: Monzo's token endpoint requires `application/x-www-form-urlencoded` bodies, and `api_adaptor`'s `JSONClient` only ever sends JSON. Exposes pure, non-interactive primitives only — no browser-launching or terminal prompts live in this gem; that orchestration belongs to a consumer.
- **`lib/monzo_adaptor/resources/`** — Optional, opt-in typed wrappers (`Data.define`-based value objects) around the Hashes `RestApi` returns, for consumers who want them. `RestApi` never returns these itself.
- **`lib/monzo_adaptor/test_helpers/`** — Mirrors `rest_api/` structure, providing `stub_*` methods for WebMock-based testing, defaulting to examples loaded from vendored docs fixtures.
- **`spec/monzo_adaptor/rest_api/`** — Unit tests using WebMock stubs.
- **`spec/fixtures/monzo_docs/`** — Vendored copies of the `monzo/docs` markdown files this gem depends on.
- **`spec/contract/`** — Tagged `contract: true`, excluded by default; fetches the live `monzo/docs` source and fails if it has drifted from the vendored copies.

## Testing Conventions

- Unit tests use `include MonzoAdaptor::TestHelpers::RestApi` for stubbing.
- Contract specs are tagged `contract: true` and excluded by default; enabled with `CONTRACT=1`. They hit `raw.githubusercontent.com` only — no other network access is permitted in specs.
- Coverage is enforced via SimpleCov: minimum 80% line, 75% branch (see `spec/spec_helper.rb`).

## Environment Variables

- `CONTRACT` — Set to `1` to run the docs-drift contract check (network access, not run in CI).

## Git Standards

Never commit to the main branch. Always create a new branch with a sensible, conventional-commit-prefixed name (`feat/`, `fix/`, `chore/`, etc.) and open a Pull Request.

## Commit Standards

Follows [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/): `<type>[optional scope]: <description>`.

- **Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`
- **Subject line** — max 50 characters, no trailing period, imperative mood
- **Body** — separated from subject by a blank line, wrapped at 72 characters, explains *why* not just *what*
- **Atomic commits** — each commit is a self-contained logical unit; avoid needing "and" in the subject line

## Development Workflow (TDD)

When adding a new resource or method, follow red-green-refactor, committing between each step:

1. **Red** — add `describe` blocks calling `stub_*` and API methods that don't exist yet. Verify `bundle exec rubocop` passes and `bundle exec rspec` fails on the new cases. Commit.
2. **Green** — add `stub_*` helpers and implement the API method(s), backed by a vendored `monzo/docs` fixture. Verify `bundle exec rake` passes. Commit.
3. **Refactor** — clean up while keeping tests green. Commit.

## Style

- Double quotes for strings
- Ruby >= 3.2
