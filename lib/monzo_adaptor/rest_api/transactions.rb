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
    end
  end
end
