# frozen_string_literal: true

require "cgi"

module MonzoAdaptor
  class RestApi
    # https://docs.monzo.com/#transactions
    module Transactions
      # Retrieve a single transaction by its id
      #
      # @param [String] transaction_id The id of the transaction
      # @param [Array<String>] expand Fields to expand, e.g. ["merchant"]
      #
      # @return [Hash] the transaction
      def get_transaction(transaction_id, expand: [])
        query = expand.map { |field| "expand[]=#{CGI.escape(field)}" }.join("&")
        query = "?#{query}" unless query.empty?
        get_json("#{endpoint}/transactions/#{CGI.escape(transaction_id)}#{query}")
      end

      # Retrieve the transactions on an account
      #
      # Note (per the docs): after 5 minutes from authentication, only the
      # last 90 days of transactions can be synced — fetch and store the
      # full history immediately after authenticating if you need it all.
      #
      # @param [String] account_id The account to retrieve transactions from
      # @param [String, nil] since RFC3339 timestamp or object id
      # @param [String, nil] before RFC3339 timestamp
      # @param [Integer, nil] limit Results per page (default 30, max 100)
      #
      # @return [Hash] the list of transactions
      def get_transactions(account_id, since: nil, before: nil, limit: nil)
        params = { account_id: account_id, since: since, before: before, limit: limit }.compact
        query = params.map { |key, value| "#{key}=#{CGI.escape(value.to_s)}" }.join("&")
        get_json("#{endpoint}/transactions?#{query}")
      end

      # Store key-value annotations against a transaction's metadata
      #
      # Metadata is private to your application. Setting a key's value to
      # an empty string deletes it. Setting the "notes" key updates the
      # transaction's top-level notes property.
      #
      # @param [String] transaction_id The id of the transaction to annotate
      # @param [Hash] metadata Metadata keys to set (or delete, with "")
      #
      # @return [ApiAdaptor::Response] the updated transaction
      def annotate_transaction(transaction_id, metadata:)
        patch_form("#{endpoint}/transactions/#{CGI.escape(transaction_id)}", metadata: metadata)
      end
    end
  end
end
