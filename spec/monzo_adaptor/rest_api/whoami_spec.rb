# frozen_string_literal: true

require "monzo_adaptor/rest_api"
require "monzo_adaptor/test_helpers/rest_api"

RSpec.describe MonzoAdaptor::RestApi::Whoami do
  include MonzoAdaptor::TestHelpers::RestApi

  let(:endpoint) { "https://api.test.monzo.com" }
  let(:api_client) { MonzoAdaptor::RestApi.new(endpoint, bearer_token: "access_token") }

  describe "#whoami" do
    it "returns the authentication status for the current access token" do
      stub_whoami
      expect(api_client.whoami.parsed_content).to eq(
        "authenticated" => true,
        "client_id" => "client_id",
        "user_id" => "user_id"
      )
    end

    it "raises a 401 response status for an invalid or expired access token" do
      stub_whoami_unauthorized
      expect { api_client.whoami }.to raise_error(ApiAdaptor::HTTPUnauthorized)
    end
  end
end
