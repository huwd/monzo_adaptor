# frozen_string_literal: true

module MonzoAdaptor
  class RestApi
    # https://docs.monzo.com/#receipts
    #
    # Unlike every other write endpoint in this gem, receipts are
    # JSON-encoded, not form-encoded — Monzo's docs call this out
    # explicitly, so this module uses put_json rather than put_form.
    module Receipts
      # Attach a receipt to a transaction (or update one, by reusing the
      # same external_id, which acts as an idempotency key)
      #
      # @param [Hash] receipt Receipt data: external_id, transaction_id,
      #   total, currency, items are required; taxes, payments and merchant
      #   are optional — see https://docs.monzo.com/#properties
      #
      # @return [Hash] the created receipt_id
      def create_receipt(receipt)
        put_json("#{endpoint}/transaction-receipts", receipt)
      end
    end
  end
end
