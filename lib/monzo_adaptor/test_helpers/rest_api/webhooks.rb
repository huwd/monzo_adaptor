# frozen_string_literal: true

require_relative "support/support"

module MonzoAdaptor
  module TestHelpers
    module RestApi
      # WebMock stubs for the Monzo /webhooks endpoints
      module Webhooks
        include MonzoAdaptor::TestHelpers::RestApi::Support

        ###############
        # POST /webhooks
        ###############

        # Stub a successful webhook registration
        #
        # @param response_body [Hash, nil] Optional response body
        #
        # @return [WebMock::RequestStub]
        def stub_register_webhook(response_body: nil)
          stub_rest_api_request(
            :post,
            "/webhooks",
            response_body: response_body || load_doc_example("_webhooks.md", "Registering a webhook")
          )
        end

        ###############
        # GET /webhooks
        ###############

        # Stub a successful webhooks list
        #
        # @param account_id [String] the account ID
        # @param response_body [Hash, nil] Optional response body
        #
        # @return [WebMock::RequestStub]
        def stub_get_webhooks(account_id, response_body: nil)
          stub_rest_api_request(
            :get,
            "/webhooks?account_id=#{account_id}",
            response_body: response_body || load_doc_example("_webhooks.md", "List webhooks")
          )
        end
      end
    end
  end
end
