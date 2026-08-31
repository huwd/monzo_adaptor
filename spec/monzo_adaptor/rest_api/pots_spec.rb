# frozen_string_literal: true

require "monzo_adaptor/rest_api"
require "monzo_adaptor/test_helpers/rest_api"

RSpec.describe MonzoAdaptor::RestApi::Pots do
  include MonzoAdaptor::TestHelpers::RestApi

  let(:endpoint) { "https://api.test.monzo.com" }
  let(:api_client) { MonzoAdaptor::RestApi.new(endpoint, bearer_token: "access_token") }
  let(:account_id) { "acc_00009237aqC8c5umZmrRdh" }

  describe "#get_pots" do
    it "returns the pots associated with the given account" do
      stub_get_pots(account_id)
      expect(api_client.get_pots(account_id).parsed_content).to eq(
        "pots" => [
          {
            "id" => "pot_0000778xxfgh4iu8z83nWb",
            "name" => "Savings",
            "style" => "beach_ball",
            "balance" => 133_700,
            "currency" => "GBP",
            "created" => "2017-11-09T12:30:53.695Z",
            "updated" => "2017-11-09T12:30:53.695Z",
            "deleted" => false
          }
        ]
      )
    end
  end
end
