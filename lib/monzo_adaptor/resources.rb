# frozen_string_literal: true

require_relative "resources/from_hash"
require_relative "resources/account"
require_relative "resources/balance"
require_relative "resources/pot"
require_relative "resources/merchant"
require_relative "resources/metadatum"

module MonzoAdaptor
  # Optional, opt-in typed value objects wrapping the Hashes that
  # MonzoAdaptor::RestApi returns. RestApi's own methods never return
  # these — a consumer builds one explicitly from a Hash it already has:
  #
  #   accounts = api_client.get_accounts.parsed_content["accounts"]
  #   MonzoAdaptor::Resources::Account.from_hash(accounts.first)
  #
  # Field lists are ported from huwd/monzo_api, an earlier gem that
  # reverse-engineered Monzo's real JSON shapes over years of use, rather
  # than re-derived from Monzo's (sparser) public docs.
  module Resources
  end
end
