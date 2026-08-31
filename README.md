# MonzoAdaptor

A Ruby wrapper around the [Monzo API](https://docs.monzo.com/), following the
same pattern as [`wikidata_adaptor`](https://github.com/huwd/wikidata_adaptor):
an [`api_adaptor`](https://github.com/huwd/api_adaptor)-based REST client with
one module per resource, plus mirrored WebMock test helpers for consumers.

It covers all nine of Monzo's documented resources (accounts, balance, pots,
transactions, feed items, attachments, receipts, webhooks, and the
`ping/whoami` auth check), OAuth2, and an optional typed value-object layer —
see below.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "monzo_adaptor"
```

## Usage

`MonzoAdaptor::RestApi` needs an access token — getting one is covered under
[OAuth](#oauth) below.

```ruby
api = MonzoAdaptor::RestApi.new("https://api.monzo.com", bearer_token: access_token)

accounts = api.get_accounts.parsed_content["accounts"]
account_id = accounts.first["id"]

balance = api.get_balance(account_id).parsed_content
balance["balance"] # => 5000 (minor units, e.g. pennies for GBP)
```

Every resource method returns a plain `Hash`/`Array` (via `ApiAdaptor::Response#parsed_content`) — not
a typed object. See `CLAUDE.md` for the full list of resource modules and
methods.

### Errors

`api_adaptor` maps HTTP status codes to exception classes
(`ApiAdaptor::HTTPNotFound`, `ApiAdaptor::HTTPUnauthorized`, ...).
`MonzoAdaptor::RestApi` additionally translates two Monzo-specific cases:

- `MonzoAdaptor::InsufficientPermissionsError` (HTTP 403) — most often means
  the user hasn't yet approved access to their data via Strong Customer
  Authentication in the Monzo app
- `MonzoAdaptor::RateLimitError` (HTTP 429) — the application is being rate
  limited

Both expose `#monzo_code` and `#monzo_message`, read from the response body,
for whatever Monzo actually sent (there's no documented enum of values to
match against).

## OAuth

`MonzoAdaptor::OAuth` implements the mechanics of Monzo's OAuth2 flow —
building the authorize URL, exchanging a code, refreshing, and logging out.
It deliberately does **not** handle the interactive part: launching a
browser, capturing the redirect, or waiting for the user to approve access
via Strong Customer Authentication in the Monzo app. That orchestration is
your application's job.

```ruby
oauth = MonzoAdaptor::OAuth.new(
  client_id: ENV.fetch("MONZO_CLIENT_ID"),
  client_secret: ENV.fetch("MONZO_CLIENT_SECRET"),
  redirect_uri: ENV.fetch("MONZO_REDIRECT_URI")
)

# 1. Send the user here to authorise your app
MonzoAdaptor::OAuth.authorize_url(
  client_id: ENV.fetch("MONZO_CLIENT_ID"),
  redirect_uri: ENV.fetch("MONZO_REDIRECT_URI"),
  state: SecureRandom.hex
)

# 2. Monzo redirects back to your redirect_uri with a `code` param —
#    exchange it for an access token. It won't have any permissions
#    until the user approves access in the Monzo app.
token = oauth.exchange_code(code)
token["access_token"]
token["refresh_token"] # only issued to confidential clients

# 3. Access tokens expire after a few hours (expires_in, in seconds).
#    Refresh when needed:
token = oauth.refresh(refresh_token)

# 4. Invalidate a token immediately (e.g. on user logout):
oauth.logout(access_token)
```

A failed request raises `MonzoAdaptor::OAuth::AuthenticationError`, exposing
`#http_code` and `#http_body`.

## Optional typed resources

`MonzoAdaptor::RestApi` always returns plain Hashes. If you'd rather work
with typed objects, `MonzoAdaptor::Resources` provides opt-in
[`Data.define`](https://docs.ruby-lang.org/en/3.2/Data.html)-based value
objects that you construct explicitly from a Hash you already have —
`RestApi` never returns them itself:

```ruby
accounts = api.get_accounts.parsed_content["accounts"]
account = MonzoAdaptor::Resources::Account.from_hash(accounts.first)
account.id
account.description
```

`.from_hash` accepts String or Symbol keys, defaults any field missing from
the hash to `nil`, and silently ignores keys it doesn't model — so it's safe
to point at a real, fuller API response rather than a purpose-built one.

Available: `Account`, `Balance`, `Pot`, `Transaction`, `Merchant`,
`Metadatum`. Field lists are ported from
[`huwd/monzo_api`](https://github.com/huwd/monzo_api), an earlier gem that
reverse-engineered Monzo's real JSON shapes (particularly `Metadatum`'s ~80
fields) over years of use, rather than re-derived from Monzo's public docs,
which don't cover most of them.

## Testing philosophy

Monzo publishes no sandbox or test environment for its API — confirmed via
[community.monzo.com](https://community.monzo.com) threads, where the
feature has been requested but never built. So:

- Unit tests (`bundle exec rspec`) run entirely offline, against fixtures
  vendored from Monzo's own docs source
  ([`monzo/docs`](https://github.com/monzo/docs)), under
  `spec/fixtures/monzo_docs/`.
- There are no tests that hit a real Monzo account.
- A separate check, tagged `contract: true` and excluded by default, fetches
  the live `monzo/docs` source and fails if it's drifted from the vendored
  copies:

  ```bash
  CONTRACT=1 bundle exec rspec spec/contract
  ```

  This is never run in CI (it needs network access to GitHub) — run it
  manually now and then, and after refreshing vendored docs:

  ```bash
  bin/refresh-monzo-docs
  ```

See `CLAUDE.md` for the full architecture and testing conventions.

## Development

```bash
bundle install
bundle exec rake   # runs rspec + rubocop
```

## License

MIT.
