# frozen_string_literal: true

module MonzoAdaptor
  module Resources
    # A transaction's `metadata` Hash.
    #
    # Monzo's `metadata` field is a loosely-documented, free-form
    # key/value store: consumers can also set their own custom keys via
    # `PATCH /transactions/:transaction_id` (see
    # MonzoAdaptor::RestApi::Transactions#annotate_transaction). This
    # field list is ported wholesale from huwd/monzo_api — specifically
    # `finance`'s (a consumer of that gem) `find_or_create_metadata`,
    # which reverse-engineered these keys from real transaction payloads
    # over years of use. None of it is in Monzo's public docs.
    #
    # @see https://docs.monzo.com/#transactions
    Metadatum = Data.define(
      :created_for_merchant, :created_for_transaction, :foursquare_category,
      :foursquare_category_icon, :foursquare_id, :foursquare_website,
      :google_places_icon, :google_places_id, :google_places_name,
      :provider, :provider_id, :suggested_name, :suggested_tags,
      :twitter_id, :website, :enriched_from_settlement, :is_topup,
      :explanation_extended, :hide_amount, :hide_transaction, :notes,
      :trip_id, :stripe_charge_id, :inbound_p2p_id, :p2p_transfer_id,
      :stripe_card_last_four, :originator_type,
      :prepaid_bridge_transfer_id, :faster_payment, :insertion, :trn,
      :ledger_insertion_id, :mastercard_auth_message_id,
      :mastercard_lifecycle_id, :mastercard_clearing_message_id,
      :is_reversal, :bacs_record_id, :bacs_direct_debit_instruction_id,
      :token_transaction_identifier, :token_unique_reference,
      :tokenization_method, :subscription_id, :action_code, :pot_id,
      :mastercard_internal_message_id, :faster_payment_initiator,
      :external_id, :trigger, :series_id, :series_iteration_count,
      :collection_id, :overdraft_days_overdrawn, :overdraft_fee,
      :overdraft_month, :p2p_initiator, :reversal_type, :fps_payment_id,
      :pot_deposit_id, :pot_withdrawal_id, :triggered_by,
      :coin_jar_transaction, :reaction, :bacs_payment_id, :mcc,
      :bill_splitting_id, :original_transaction_id, :payment_request_id,
      :mastercard_approval_type, :user_id, :payday, :pot_account_id,
      :tab_id, :exclude_from_breakdown,
      :mastercard_partial_approval_supported, :is_eligible_for_bill_split,
      :premium_period_id, :premium_subscription_id, :subscription_type,
      :mastercard_acquirer_completed, :payout_month,
      :international_payment, :international_payment_provider,
      :international_payment_reference, :transferwise_transfer_id,
      :fps_fpid, :mastercard_card_id, :cheque, :cheque_id
    ) do
      extend MonzoAdaptor::Resources::FromHash
    end
  end
end
