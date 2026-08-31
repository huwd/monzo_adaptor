# frozen_string_literal: true

require_relative "support/support"

module MonzoAdaptor
  module TestHelpers
    module RestApi
      # WebMock stubs for the Monzo /transaction-receipts endpoints
      module Receipts
        include MonzoAdaptor::TestHelpers::RestApi::Support

        ###############################
        # PUT /transaction-receipts
        ###############################

        # Stub a successful receipt creation
        #
        # Unlike load_doc_example's usual role, this doesn't load from
        # _receipts.md: "Create receipt" has two JSON blocks (request then
        # response), and the response one ({"receipt_id": ..., ...}) isn't
        # valid JSON — it contains a literal "..." placeholder. Verified
        # against the live source, not just our vendored copy.
        #
        # @param response_body [Hash, nil] Optional response body
        #
        # @return [WebMock::RequestStub]
        def stub_create_receipt(response_body: nil)
          stub_rest_api_request(
            :put,
            "/transaction-receipts",
            response_body: response_body || { receipt_id: "receipt_00009NrKwNtI3gKqte" }
          )
        end
      end
    end
  end
end
