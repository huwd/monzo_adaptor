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

  describe "#get_transactions" do
    let(:account_id) { "acc_00009237aqC8c5umZmrRdh" }

    it "returns the transactions on the given account" do
      stub_get_transactions(account_id)
      transactions = api_client.get_transactions(account_id).parsed_content["transactions"]

      expect(transactions.map { |t| t["id"] }).to eq(%w[tx_00008zIcpb1TB4yeIFXMzx tx_00008zL2INM3xZ41THuRF3])
    end

    it "supports since/before/limit pagination params" do
      stub_get_transactions(account_id)
      api_client.get_transactions(account_id, since: "2020-01-01T00:00:00Z", before: "2020-02-01T00:00:00Z", limit: 50)

      expect(WebMock).to have_requested(:get, "#{endpoint}/transactions")
        .with(query: { "account_id" => account_id, "since" => "2020-01-01T00:00:00Z", "before" => "2020-02-01T00:00:00Z", "limit" => "50" })
    end
  end

  describe "#annotate_transaction" do
    it "sets metadata keys on a transaction, form-encoding the request" do
      stub_annotate_transaction(transaction_id)
      response = api_client.annotate_transaction(transaction_id, metadata: { "foo" => "bar" })

      expect(response.parsed_content["transaction"]).to include("id" => "tx_00008zL2INM3xZ41THuRF3")
      expect(WebMock).to have_requested(:patch, "#{endpoint}/transactions/#{transaction_id}")
        .with(
          body: { "metadata" => { "foo" => "bar" } },
          headers: { "Content-Type" => "application/x-www-form-urlencoded" }
        )
    end
  end
end
