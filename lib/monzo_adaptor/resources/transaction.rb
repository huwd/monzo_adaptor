# frozen_string_literal: true

module MonzoAdaptor
  module Resources
    # A movement of funds into or out of an account.
    #
    # `merchant` and `metadata` are left as the raw values Monzo returns —
    # a merchant id String, or an expanded Hash (depending on whether
    # `expand[]=merchant` was requested); a metadata Hash — rather than
    # auto-wrapped. Wrap them explicitly with
    # MonzoAdaptor::Resources::Merchant/Metadatum if needed.
    #
    # @see https://docs.monzo.com/#transactions
    Transaction = Data.define(
      :id, :description, :amount, :fees, :currency, :notes, :labels,
      :account_balance, :international, :category, :settled,
      :local_amount, :local_currency, :account_id, :user_id,
      :counterparty, :scheme, :dedupe_id, :decline_reason, :created,
      :updated, :amount_is_pending, :can_add_to_tab, :originator,
      :can_be_excluded_from_breakdown, :can_be_made_subscription,
      :can_split_the_bill, :include_in_spending, :is_load, :merchant,
      :metadata
    ) do
      extend MonzoAdaptor::Resources::FromHash
    end
  end
end
