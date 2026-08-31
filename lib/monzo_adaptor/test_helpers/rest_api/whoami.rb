# frozen_string_literal: true

require_relative "support/support"

module MonzoAdaptor
  module TestHelpers
    module RestApi
      # WebMock stubs for the Monzo /ping/whoami endpoint
      module Whoami
        include MonzoAdaptor::TestHelpers::RestApi::Support

        ###############
        # GET /ping/whoami
        ###############

        # Stub a successful whoami check
        #
        # @param response_body [Hash, nil] Optional response body
        #
        # @return [WebMock::RequestStub]
        def stub_whoami(response_body: nil)
          stub_rest_api_request(
            :get,
            "/ping/whoami",
            response_body: response_body || load_doc_example("_authentication.md", "Authenticating requests")
          )
        end

        # Stub a whoami check with an invalid/expired access token
        #
        # @return [WebMock::RequestStub]
        def stub_whoami_unauthorized
          stub_rest_api_request(
            :get,
            "/ping/whoami",
            response_status: 401,
            response_body: { code: "unauthorized.bad_access_token", message: "Bad access token" }
          )
        end
      end
    end
  end
end
