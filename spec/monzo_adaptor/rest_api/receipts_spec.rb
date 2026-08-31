# frozen_string_literal: true

require "monzo_adaptor/rest_api"
require "monzo_adaptor/test_helpers/rest_api"

RSpec.describe MonzoAdaptor::RestApi::Receipts do
  include MonzoAdaptor::TestHelpers::RestApi

  let(:endpoint) { "https://api.test.monzo.com" }
  let(:api_client) { MonzoAdaptor::RestApi.new(endpoint, bearer_token: "access_token") }
  let(:receipt) do
    {
      transaction_id: "tx_00008zIcpb1TB4yeIFXMzx",
      external_id: "test-receipt-1",
      total: 1299,
      currency: "GBP",
      items: [{ description: "Bananas, 70p per kg", quantity: 18.56, unit: "kg", amount: 70, currency: "GBP" }]
    }
  end

  describe "#create_receipt" do
    it "attaches a receipt to a transaction, JSON-encoding the request" do
      stub_create_receipt
      response = api_client.create_receipt(receipt)

      expect(response.parsed_content).to eq("receipt_id" => "receipt_00009NrKwNtI3gKqte")
      expect(WebMock).to have_requested(:put, "#{endpoint}/transaction-receipts")
        .with(body: receipt.transform_keys(&:to_s), headers: { "Content-Type" => "application/json" })
    end
  end

  describe "#get_receipt" do
    it "retrieves a receipt by its external_id" do
      stub_get_receipt("test-receipt-1")
      expect(api_client.get_receipt("test-receipt-1").parsed_content["receipt"]).to include(
        "id" => "receipt_00009eNJqNeJvKeoQA",
        "external_id" => "test-receipt-1"
      )
    end
  end

  describe "#delete_receipt" do
    it "deletes a receipt by its external_id" do
      stub_delete_receipt("test-receipt-1")
      expect(api_client.delete_receipt("test-receipt-1").parsed_content).to eq({})
    end
  end
end
