# frozen_string_literal: true

require_relative "support/support"

module MonzoAdaptor
  module TestHelpers
    module RestApi
      # WebMock stubs for the Monzo /accounts endpoint
      module Accounts
        include MonzoAdaptor::TestHelpers::RestApi::Support

        ###############
        # GET /accounts
        ###############

        # Stub a successful accounts list
        #
        # @param account_type [String, nil] if given, only stub the request when filtered by this account_type
        # @param response_body [Hash, nil] Optional response body
        #
        # @return [WebMock::RequestStub]
        def stub_get_accounts(account_type: nil, response_body: nil)
          path = account_type ? "/accounts?account_type=#{account_type}" : "/accounts"
          stub_rest_api_request(
            :get,
            path,
            response_body: response_body || load_doc_example("_accounts.md", "List accounts")
          )
        end
      end
    end
  end
end
