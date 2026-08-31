# frozen_string_literal: true

require "monzo_adaptor/rest_api"
require "monzo_adaptor/test_helpers/rest_api"

RSpec.describe MonzoAdaptor::RestApi::Balance do
  include MonzoAdaptor::TestHelpers::RestApi

  let(:endpoint) { "https://api.test.monzo.com" }
  let(:api_client) { MonzoAdaptor::RestApi.new(endpoint, bearer_token: "access_token") }
  let(:account_id) { "acc_00009237aqC8c5umZmrRdh" }

  describe "#get_balance" do
    it "returns balance information for the given account" do
      stub_get_balance(account_id)
      expect(api_client.get_balance(account_id).parsed_content).to eq(
        "balance" => 5000,
        "total_balance" => 6000,
        "currency" => "GBP",
        "spend_today" => 0
      )
    end
  end
end
