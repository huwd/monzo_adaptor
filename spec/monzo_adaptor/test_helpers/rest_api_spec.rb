# frozen_string_literal: true

require "monzo_adaptor/rest_api"
require "monzo_adaptor/test_helpers/rest_api"

RSpec.describe MonzoAdaptor::TestHelpers::RestApi do
  include described_class

  let(:endpoint) { "https://api.test.monzo.com" }
  let(:api_client) { MonzoAdaptor::RestApi.new(endpoint, bearer_token: "access_token") }

  describe "#stub_rest_api_request" do
    it "matches requests against the given :with criteria" do
      stub_rest_api_request(:get, "/ping/whoami", with: { headers: { "Authorization" => "Bearer access_token" } })

      expect(api_client.whoami.parsed_content).to eq({})
    end

    it "returns a plain String response body as-is, without JSON-encoding it" do
      stub_rest_api_request(:get, "/ping/whoami", response_body: "pong")

      expect(api_client.whoami.raw_response_body).to eq("pong")
    end
  end
end
