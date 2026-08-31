# frozen_string_literal: true

require_relative "support/support"

module MonzoAdaptor
  module TestHelpers
    module RestApi
      # WebMock stubs for the Monzo /transactions endpoints
      module Transactions
        include MonzoAdaptor::TestHelpers::RestApi::Support

        ###############################
        # GET /transactions/:transaction_id
        ###############################

        # Stub a successful single transaction retrieval
        #
        # @param transaction_id [String] the transaction ID
        # @param response_body [Hash, nil] Optional response body
        #
        # @return [WebMock::RequestStub]
        def stub_get_transaction(transaction_id, expand: [], response_body: nil)
          query = expand.map { |field| "expand[]=#{field}" }.join("&")
          path = "/transactions/#{transaction_id}#{"?#{query}" unless query.empty?}"
          stub_rest_api_request(
            :get,
            path,
            response_body: response_body || load_doc_example("_transactions.md", "Retrieve transaction")
          )
        end
      end
    end
  end
end
