# frozen_string_literal: true

module MonzoAdaptor
  module Resources
    # An account's balance.
    #
    # @see https://docs.monzo.com/#balance
    Balance = Data.define(
      :balance, :total_balance, :currency, :spend_today,
      :local_currency, :local_spend, :local_exchange_rate,
      :balance_including_flexible_savings
    ) do
      extend MonzoAdaptor::Resources::FromHash
    end
  end
end
