# frozen_string_literal: true

require_relative "support/support"

module MonzoAdaptor
  module TestHelpers
    module RestApi
      # WebMock stubs for the Monzo /pots endpoints
      module Pots
        include MonzoAdaptor::TestHelpers::RestApi::Support

        ###############
        # GET /pots
        ###############

        # Stub a successful pots list
        #
        # @param account_id [String] the current account ID
        # @param response_body [Hash, nil] Optional response body
        #
        # @return [WebMock::RequestStub]
        def stub_get_pots(account_id, response_body: nil)
          stub_rest_api_request(
            :get,
            "/pots?current_account_id=#{account_id}",
            response_body: response_body || load_doc_example("_pots.md", "List pots")
          )
        end
      end
    end
  end
end
