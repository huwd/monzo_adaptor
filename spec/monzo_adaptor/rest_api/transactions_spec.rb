# frozen_string_literal: true

require "monzo_adaptor/rest_api"
require "monzo_adaptor/test_helpers/rest_api"

RSpec.describe MonzoAdaptor::RestApi::Transactions do
  include MonzoAdaptor::TestHelpers::RestApi

  let(:endpoint) { "https://api.test.monzo.com" }
  let(:api_client) { MonzoAdaptor::RestApi.new(endpoint, bearer_token: "access_token") }
  let(:transaction_id) { "tx_00008zIcpb1TB4yeIFXMzx" }

  describe "#get_transaction" do
    it "returns the transaction by its id" do
      stub_get_transaction(transaction_id)
      expect(api_client.get_transaction(transaction_id).parsed_content["transaction"]).to include(
        "id" => transaction_id,
        "amount" => -510
      )
    end

    it "expands the given fields" do
      stub_get_transaction(transaction_id, expand: ["merchant"])
      api_client.get_transaction(transaction_id, expand: ["merchant"])

      expect(WebMock).to have_requested(:get, "#{endpoint}/transactions/#{transaction_id}?expand[]=merchant")
    end
  end
end
