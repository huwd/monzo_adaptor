# frozen_string_literal: true

require "monzo_adaptor/rest_api"

RSpec.describe MonzoAdaptor::RestApi do
  let(:endpoint) { "https://api.test.monzo.com" }
  let(:api_client) { described_class.new(endpoint) }

  describe "error translation" do
    it "raises MonzoAdaptor::InsufficientPermissionsError on a 403 response" do
      stub_request(:get, "#{endpoint}/whoami")
        .to_return(status: 403, body: { code: "forbidden.verification_required", message: "nope" }.to_json)

      expect { api_client.get_json("#{endpoint}/whoami") }
        .to raise_error(MonzoAdaptor::InsufficientPermissionsError) do |error|
          expect(error.monzo_code).to eq("forbidden.verification_required")
        end
    end

    it "raises MonzoAdaptor::RateLimitError on a 429 response" do
      stub_request(:get, "#{endpoint}/whoami")
        .to_return(status: 429, body: { code: "too_many_requests", message: "slow down" }.to_json)

      expect { api_client.get_json("#{endpoint}/whoami") }
        .to raise_error(MonzoAdaptor::RateLimitError) do |error|
          expect(error.monzo_code).to eq("too_many_requests")
        end
    end

    it "leaves other HTTP errors untranslated" do
      stub_request(:get, "#{endpoint}/whoami").to_return(status: 404, body: "{}")

      expect { api_client.get_json("#{endpoint}/whoami") }.to raise_error(ApiAdaptor::HTTPNotFound)
    end
  end
end
