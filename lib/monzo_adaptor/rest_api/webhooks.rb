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

      # Delete a webhook; Monzo will stop sending it notifications
      #
      # @param [String] webhook_id The id of the webhook to delete
      #
      # @return [ApiAdaptor::Response] an empty response on success
      def delete_webhook(webhook_id)
        delete_json("#{endpoint}/webhooks/#{CGI.escape(webhook_id)}")
      end
    end
  end
end
