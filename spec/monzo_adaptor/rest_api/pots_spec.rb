# frozen_string_literal: true

require "monzo_adaptor/rest_api"
require "monzo_adaptor/test_helpers/rest_api"

RSpec.describe MonzoAdaptor::RestApi::Pots do
  include MonzoAdaptor::TestHelpers::RestApi

  let(:endpoint) { "https://api.test.monzo.com" }
  let(:api_client) { MonzoAdaptor::RestApi.new(endpoint, bearer_token: "access_token") }
  let(:account_id) { "acc_00009237aqC8c5umZmrRdh" }
  let(:pot_id) { "pot_0000778xxfgh4iu8z83nWb" }

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

  describe "#deposit_into_pot" do
    it "moves money from an account into a pot, form-encoding the request" do
      stub_deposit_into_pot(pot_id)
      response = api_client.deposit_into_pot(
        pot_id, source_account_id: account_id, amount: 550_100, dedupe_id: "dedupe_1"
      )

      expect(response.parsed_content).to include("id" => "pot_00009exampleP0tOxWb", "balance" => 550_100)
      expect(WebMock).to have_requested(:put, "#{endpoint}/pots/#{pot_id}/deposit")
        .with(
          body: { "source_account_id" => account_id, "amount" => "550100", "dedupe_id" => "dedupe_1" },
          headers: { "Content-Type" => "application/x-www-form-urlencoded" }
        )
    end
  end
end
