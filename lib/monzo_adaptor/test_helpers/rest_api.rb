# frozen_string_literal: true

require "json"
require "webmock"

module MonzoAdaptor
  module TestHelpers
    # WebMock stubs for the Monzo REST API
    #
    # Include this module in your RSpec tests to access stub methods for
    # Monzo REST API endpoints.
    module RestApi
      require_relative "rest_api/support/support"
      require_relative "rest_api/whoami"
      require_relative "rest_api/accounts"
      require_relative "rest_api/balance"
      require_relative "rest_api/pots"
      require_relative "rest_api/transactions"
      require_relative "rest_api/feed_items"
      require_relative "rest_api/attachments"
      require_relative "rest_api/receipts"
      include MonzoAdaptor::TestHelpers::RestApi::Support
      include MonzoAdaptor::TestHelpers::RestApi::Whoami
      include MonzoAdaptor::TestHelpers::RestApi::Accounts
      include MonzoAdaptor::TestHelpers::RestApi::Balance
      include MonzoAdaptor::TestHelpers::RestApi::Pots
      include MonzoAdaptor::TestHelpers::RestApi::Transactions
      include MonzoAdaptor::TestHelpers::RestApi::FeedItems
      include MonzoAdaptor::TestHelpers::RestApi::Attachments
      include MonzoAdaptor::TestHelpers::RestApi::Receipts

      # Default test endpoint for stubbed requests
      MONZO_REST_ENDPOINT = ENV["MONZO_REST_ENDPOINT"] || "https://api.test.monzo.com"

      # Stub a Monzo REST API request with WebMock
      #
      # This is the base method used by all specific stub_* helpers.
      # Use the specific stub methods instead of calling this directly.
      #
      # @param [Symbol] method HTTP method (:get, :post, :put, :patch, :delete)
      # @param [String] path API path (e.g., "/ping/whoami")
      # @param [Hash] with Optional request matching criteria
      # @param [Integer] response_status HTTP status code to return
      # @param [Hash] response_headers HTTP headers to return
      # @param [Hash, Array, String] response_body Response body
      #
      # @return [WebMock::RequestStub] The configured stub
      def stub_rest_api_request(method, path, with: {}, response_status: 200, response_headers: {}, response_body: {})
        to_return = { status: response_status, headers: response_headers, body: prepare_response(response_body) }
        if with.empty?
          stub_request(method, "#{MONZO_REST_ENDPOINT}#{path}").to_return(**to_return)
        else
          stub_request(method, "#{MONZO_REST_ENDPOINT}#{path}").with(**with).to_return(**to_return)
        end
      end

      private

      def prepare_response(response_body)
        case response_body
        when String
          response_body
        else
          response_body.to_json
        end
      end
    end
  end
end
