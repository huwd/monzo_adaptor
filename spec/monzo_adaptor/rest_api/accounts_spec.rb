# frozen_string_literal: true

require "monzo_adaptor/rest_api"
require "monzo_adaptor/test_helpers/rest_api"

RSpec.describe MonzoAdaptor::RestApi::Accounts do
  include MonzoAdaptor::TestHelpers::RestApi

  let(:endpoint) { "https://api.test.monzo.com" }
  let(:api_client) { MonzoAdaptor::RestApi.new(endpoint, bearer_token: "access_token") }

  describe "#get_accounts" do
    it "returns the list of accounts owned by the current user" do
      stub_get_accounts
      expect(api_client.get_accounts.parsed_content).to eq(
        "accounts" => [
          { "id" => "acc_00009237aqC8c5umZmrRdh", "description" => "Peter Pan's Account", "created" => "2015-11-13T12:17:42Z" }
        ]
      )
    end

    it "filters by account_type when given" do
      stub_get_accounts(account_type: "uk_retail")
      api_client.get_accounts(account_type: "uk_retail")

      expect(WebMock).to have_requested(:get, "#{endpoint}/accounts?account_type=uk_retail")
    end
  end
end
