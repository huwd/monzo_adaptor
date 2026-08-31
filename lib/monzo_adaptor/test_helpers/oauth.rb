# frozen_string_literal: true

require_relative "rest_api/support/support"

module MonzoAdaptor
  module TestHelpers
    # WebMock stubs for the Monzo OAuth2 endpoints
    module OAuth
      include MonzoAdaptor::TestHelpers::RestApi::Support

      TOKEN_URL = "https://api.monzo.com/oauth2/token"
      LOGOUT_URL = "https://api.monzo.com/oauth2/logout"

      # Stub a successful authorization code exchange
      def stub_exchange_code(response_body: nil)
        stub_request(:post, TOKEN_URL)
          .with(body: hash_including(grant_type: "authorization_code"))
          .to_return(
            status: 200,
            body: (response_body || load_doc_example("_authentication.md", "Exchange the authorization code")).to_json
          )
      end

      # Stub a failed authorization code exchange
      def stub_exchange_code_failure(response_status: 400, response_body: { error: "invalid_grant" })
        stub_request(:post, TOKEN_URL)
          .with(body: hash_including(grant_type: "authorization_code"))
          .to_return(status: response_status, body: response_body.to_json)
      end

      # Stub a successful token refresh
      def stub_refresh(response_body: nil)
        stub_request(:post, TOKEN_URL)
          .with(body: hash_including(grant_type: "refresh_token"))
          .to_return(
            status: 200,
            body: (response_body || load_doc_example("_authentication.md", "Refreshing access")).to_json
          )
      end

      # Stub a failed token refresh
      def stub_refresh_failure(response_status: 400, response_body: { error: "invalid_grant" })
        stub_request(:post, TOKEN_URL)
          .with(body: hash_including(grant_type: "refresh_token"))
          .to_return(status: response_status, body: response_body.to_json)
      end

      # Stub a successful logout
      def stub_logout(access_token)
        stub_request(:post, LOGOUT_URL)
          .with(headers: { "Authorization" => "Bearer #{access_token}" })
          .to_return(status: 200, body: "")
      end

      # Stub a failed logout
      def stub_logout_failure(access_token, response_status: 401, response_body: { error: "invalid_token" })
        stub_request(:post, LOGOUT_URL)
          .with(headers: { "Authorization" => "Bearer #{access_token}" })
          .to_return(status: response_status, body: response_body.to_json)
      end
    end
  end
end
