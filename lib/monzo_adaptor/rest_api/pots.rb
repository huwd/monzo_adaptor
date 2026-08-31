# frozen_string_literal: true

require "cgi"

module MonzoAdaptor
  class RestApi
    # https://docs.monzo.com/#pots
    module Pots
      # Retrieve the pots associated with an account
      #
      # @param [String] current_account_id The account the pots are associated with
      #
      # @return [Hash] the list of pots
      def get_pots(current_account_id)
        get_json("#{endpoint}/pots?current_account_id=#{CGI.escape(current_account_id)}")
      end
    end
  end
end
