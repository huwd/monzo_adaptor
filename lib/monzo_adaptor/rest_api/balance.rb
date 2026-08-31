# frozen_string_literal: true

require "cgi"

module MonzoAdaptor
  class RestApi
    # https://docs.monzo.com/#balance
    module Balance
      # Retrieve balance information for a specific account
      #
      # @param [String] account_id The id of the account
      #
      # @return [Hash] balance, total_balance, currency and spend_today
      def get_balance(account_id)
        get_json("#{endpoint}/balance?account_id=#{CGI.escape(account_id)}")
      end
    end
  end
end
