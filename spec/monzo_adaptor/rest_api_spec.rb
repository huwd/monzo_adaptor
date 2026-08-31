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

  describe "#put_form and #post_form" do
    it "sends a form-encoded PUT and returns a Response-like object" do
      stub_request(:put, "#{endpoint}/pots/pot_123/deposit")
        .with(body: { "amount" => "100" }, headers: { "Content-Type" => "application/x-www-form-urlencoded" })
        .to_return(status: 200, body: { id: "pot_123", balance: 100 }.to_json)

      response = api_client.send(:put_form, "#{endpoint}/pots/pot_123/deposit", amount: 100)

      expect(response.parsed_content).to eq("id" => "pot_123", "balance" => 100)
    end

    it "sends a form-encoded POST and returns a Response-like object" do
      stub_request(:post, "#{endpoint}/feed")
        .with(body: { "type" => "basic" }, headers: { "Content-Type" => "application/x-www-form-urlencoded" })
        .to_return(status: 200, body: "{}")

      response = api_client.send(:post_form, "#{endpoint}/feed", type: "basic")

      expect(response.parsed_content).to eq({})
    end

    it "translates 403s from form requests the same way as JSON requests" do
      stub_request(:put, "#{endpoint}/pots/pot_123/deposit")
        .to_return(status: 403, body: { code: "forbidden.verification_required", message: "nope" }.to_json)

      expect { api_client.send(:put_form, "#{endpoint}/pots/pot_123/deposit", amount: 100) }
        .to raise_error(MonzoAdaptor::InsufficientPermissionsError)
    end

    it "raises the generic ApiAdaptor HTTP error for other statuses" do
      stub_request(:put, "#{endpoint}/pots/pot_123/deposit").to_return(status: 404, body: "{}")

      expect { api_client.send(:put_form, "#{endpoint}/pots/pot_123/deposit", amount: 100) }
        .to raise_error(ApiAdaptor::HTTPNotFound)
    end

    it "is nil-safe when the error response body isn't JSON" do
      stub_request(:put, "#{endpoint}/pots/pot_123/deposit").to_return(status: 500, body: "oops")

      expect { api_client.send(:put_form, "#{endpoint}/pots/pot_123/deposit", amount: 100) }
        .to raise_error(ApiAdaptor::HTTPInternalServerError)
    end
  end
end
