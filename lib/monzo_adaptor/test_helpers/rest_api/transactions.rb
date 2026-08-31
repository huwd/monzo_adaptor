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

        ###############################
        # GET /transactions
        ###############################

        # Stub a successful transactions list
        #
        # @param account_id [String] the account ID
        # @param response_body [Hash, nil] Optional response body
        #
        # @return [WebMock::RequestStub]
        def stub_get_transactions(account_id, response_body: nil)
          stub_rest_api_request(
            :get,
            "/transactions",
            with: { query: hash_including("account_id" => account_id) },
            response_body: response_body || list_transactions_response_fixture
          )
        end

        # monzo/docs' "List transactions" JSON example has a trailing comma
        # after the last array element, which isn't valid JSON (verified
        # against the live source, not just our vendored copy — see
        # spec/contract/docs_sync_spec.rb). Hand-corrected here rather than
        # in the vendored file, so the contract check keeps comparing byte
        # for byte against what Monzo actually publishes.
        #
        # @return [Hash]
        def list_transactions_response_fixture
          {
            transactions: [
              {
                amount: -510,
                created: "2015-08-22T12:20:18Z",
                currency: "GBP",
                description: "THE DE BEAUVOIR DELI C LONDON        GBR",
                id: "tx_00008zIcpb1TB4yeIFXMzx",
                merchant: "merch_00008zIcpbAKe8shBxXUtl",
                metadata: {},
                notes: "Salmon sandwich 🍞",
                is_load: false,
                settled: "2015-08-23T12:20:18Z",
                category: "eating_out"
              },
              {
                amount: -679,
                created: "2015-08-23T16:15:03Z",
                currency: "GBP",
                description: "VUE BSL LTD            ISLINGTON     GBR",
                id: "tx_00008zL2INM3xZ41THuRF3",
                merchant: "merch_00008z6uFVhVBcaZzSQwCX",
                metadata: {},
                notes: "",
                is_load: false,
                settled: "2015-08-24T16:15:03Z",
                category: "eating_out"
              }
            ]
          }
        end
      end
    end
  end
end
