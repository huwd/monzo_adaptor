# frozen_string_literal: true

require "monzo_adaptor/oauth"
require "monzo_adaptor/test_helpers/oauth"

RSpec.describe MonzoAdaptor::OAuth do
  include MonzoAdaptor::TestHelpers::OAuth

  let(:client_id) { "client_id" }
  let(:client_secret) { "client_secret" }
  let(:redirect_uri) { "https://example.com/oauth/callback" }
  let(:oauth) { described_class.new(client_id:, client_secret:, redirect_uri:) }

  describe ".authorize_url" do
    it "builds the Monzo authorization URL with the required parameters" do
      url = described_class.authorize_url(client_id:, redirect_uri:, state: "some-state")
      uri = URI(url)
      params = URI.decode_www_form(uri.query).to_h

      expect(uri.host).to eq("auth.monzo.com")
      expect(params).to eq(
        "client_id" => client_id,
        "redirect_uri" => redirect_uri,
        "response_type" => "code",
        "state" => "some-state"
      )
    end
  end

  describe "#exchange_code" do
    it "exchanges an authorization code for an access token" do
      stub_exchange_code
      token = oauth.exchange_code("auth_code")

      expect(token).to include("access_token" => "access_token", "refresh_token" => "refresh_token")
    end

    it "raises MonzoAdaptor::OAuth::AuthenticationError on a failed exchange" do
      stub_exchange_code_failure

      expect { oauth.exchange_code("bad_code") }.to raise_error(MonzoAdaptor::OAuth::AuthenticationError)
    end
  end

  describe "#refresh" do
    it "exchanges a refresh token for a new access token" do
      stub_refresh
      token = oauth.refresh("refresh_token")

      expect(token).to include("access_token" => "access_token_2", "refresh_token" => "refresh_token_2")
    end

    it "raises MonzoAdaptor::OAuth::AuthenticationError on a failed refresh" do
      stub_refresh_failure

      expect { oauth.refresh("bad_refresh_token") }.to raise_error(MonzoAdaptor::OAuth::AuthenticationError)
    end
  end

  describe "#logout" do
    it "invalidates the given access token" do
      stub_logout("access_token")

      expect(oauth.logout("access_token")).to be true
    end

    it "raises MonzoAdaptor::OAuth::AuthenticationError on a failed logout" do
      stub_logout_failure("bad_access_token")

      expect { oauth.logout("bad_access_token") }.to raise_error(MonzoAdaptor::OAuth::AuthenticationError)
    end
  end
end
