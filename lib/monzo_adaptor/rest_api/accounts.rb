# frozen_string_literal: true

require "cgi"

module MonzoAdaptor
  class RestApi
    # https://docs.monzo.com/#accounts
    module Accounts
      # Retrieve the accounts owned by the current user
      #
      # @param [String, nil] account_type Filter to "uk_retail" or "uk_retail_joint"
      #
      # @return [Hash] the list of accounts
      def get_accounts(account_type: nil)
        query = account_type ? "?account_type=#{CGI.escape(account_type)}" : ""
        get_json("#{endpoint}/accounts#{query}")
      end
    end
  end
end
