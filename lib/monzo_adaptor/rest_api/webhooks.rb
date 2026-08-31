# frozen_string_literal: true

require "cgi"

module MonzoAdaptor
  class RestApi
    # https://docs.monzo.com/#webhooks
    module Webhooks
      # Register a webhook to receive real-time events for an account
      #
      # If a call to the webhook URL fails, Monzo retries up to 5 times
      # with exponential backoff.
      #
      # @param [String] account_id The account to receive notifications for
      # @param [String] url The URL Monzo will send notifications to
      #
      # @return [ApiAdaptor::Response] the registered webhook
      def register_webhook(account_id:, url:)
        post_form("#{endpoint}/webhooks", account_id: account_id, url: url)
      end

      # List the webhooks registered on an account
      #
      # @param [String] account_id The account to list registered webhooks for
      #
      # @return [Hash] the list of webhooks
      def get_webhooks(account_id)
        get_json("#{endpoint}/webhooks?account_id=#{CGI.escape(account_id)}")
      end
    end
  end
end
