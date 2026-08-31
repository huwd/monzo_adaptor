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
    end
  end
end
