# frozen_string_literal: true

require "cgi"

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

      # Retrieve a receipt you created, by its external_id
      #
      # @param [String] external_id The external ID of the receipt
      #
      # @return [Hash] the receipt
      def get_receipt(external_id)
        get_json("#{endpoint}/transaction-receipts?external_id=#{CGI.escape(external_id)}")
      end

      # Delete a receipt, by its external_id
      #
      # @param [String] external_id The external ID of the receipt
      #
      # @return [ApiAdaptor::Response] an empty response on success
      def delete_receipt(external_id)
        delete_json("#{endpoint}/transaction-receipts?external_id=#{CGI.escape(external_id)}")
      end
    end
  end
end
