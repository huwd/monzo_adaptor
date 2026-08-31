# frozen_string_literal: true

module MonzoAdaptor
  module Resources
    # An account: a store of funds, with a list of transactions.
    #
    # @see https://docs.monzo.com/#accounts
    Account = Data.define(:id, :description, :created, :type, :currency, :country_code, :closed) do
      extend MonzoAdaptor::Resources::FromHash
    end
  end
end
