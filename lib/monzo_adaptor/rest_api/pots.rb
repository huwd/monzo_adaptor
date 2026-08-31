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

      # Move money from an account into a pot
      #
      # @param [String] pot_id The id of the pot to deposit into
      # @param [String] source_account_id The id of the account to withdraw from
      # @param [Integer] amount The amount to deposit, in minor units
      # @param [String] dedupe_id A unique string used to de-duplicate deposits
      #
      # @return [ApiAdaptor::Response] the updated pot
      def deposit_into_pot(pot_id, source_account_id:, amount:, dedupe_id:)
        put_form(
          "#{endpoint}/pots/#{CGI.escape(pot_id)}/deposit",
          source_account_id: source_account_id, amount: amount, dedupe_id: dedupe_id
        )
      end

      # Move money from a pot into an account
      #
      # @param [String] pot_id The id of the pot to withdraw from
      # @param [String] destination_account_id The id of the account to deposit into
      # @param [Integer] amount The amount to withdraw, in minor units
      # @param [String] dedupe_id A unique string used to de-duplicate withdrawals
      #
      # @return [ApiAdaptor::Response] the updated pot
      def withdraw_from_pot(pot_id, destination_account_id:, amount:, dedupe_id:)
        put_form(
          "#{endpoint}/pots/#{CGI.escape(pot_id)}/withdraw",
          destination_account_id: destination_account_id, amount: amount, dedupe_id: dedupe_id
        )
      end
    end
  end
end
