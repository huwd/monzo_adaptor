# frozen_string_literal: true

require_relative "support/support"

module MonzoAdaptor
  module TestHelpers
    module RestApi
      # WebMock stubs for the Monzo /balance endpoint
      module Balance
        include MonzoAdaptor::TestHelpers::RestApi::Support

        ###############
        # GET /balance
        ###############

        # Stub a successful balance read
        #
        # @param account_id [String] the account ID
        # @param response_body [Hash, nil] Optional response body
        #
        # @return [WebMock::RequestStub]
        def stub_get_balance(account_id, response_body: nil)
          stub_rest_api_request(
            :get,
            "/balance?account_id=#{account_id}",
            response_body: response_body || load_doc_example("_balance.md", "Read balance")
          )
        end
      end
    end
  end
end
