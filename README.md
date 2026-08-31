# MonzoAdaptor

A Ruby wrapper around the [Monzo API](https://docs.monzo.com/), following the
same pattern as [`wikidata_adaptor`](https://github.com/huwd/wikidata_adaptor):
an [`api_adaptor`](https://github.com/huwd/api_adaptor)-based REST client with
one module per resource, plus mirrored WebMock test helpers for consumers.

Status: early scaffold — see `CLAUDE.md` for the architecture and rollout
plan.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "monzo_adaptor"
```

## Development

```bash
bundle install
bundle exec rake   # runs rspec + rubocop
```

Unit tests run entirely offline, against fixtures vendored from Monzo's
public docs source ([`monzo/docs`](https://github.com/monzo/docs)). There is
no official Monzo sandbox, so there are no tests that hit a real Monzo
account. See `CLAUDE.md` for details, including the separate (non-CI)
contract check that diffs vendored fixtures against the live docs source.

## License

MIT.
