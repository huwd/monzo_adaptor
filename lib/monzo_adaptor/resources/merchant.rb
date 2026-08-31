# frozen_string_literal: true

module MonzoAdaptor
  module Resources
    # The merchant a transaction was made at.
    #
    # `address` is left as the raw Hash Monzo returns, rather than wrapped
    # further.
    #
    # @see https://docs.monzo.com/#transactions
    Merchant = Data.define(:id, :group_id, :name, :logo, :emoji, :category, :online, :disable_feedback, :address) do
      extend MonzoAdaptor::Resources::FromHash
    end
  end
end
