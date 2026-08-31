# frozen_string_literal: true

require "monzo_adaptor/resources"
require "monzo_adaptor/test_helpers/rest_api/support/support"
require "monzo_adaptor/test_helpers/rest_api/transactions"

RSpec.describe MonzoAdaptor::Resources::Transaction do
  include MonzoAdaptor::TestHelpers::RestApi::Support
  include MonzoAdaptor::TestHelpers::RestApi::Transactions

  describe ".from_hash" do
    it "builds from the documented single-transaction example, wrapping merchant as a Hash" do
      hash = load_doc_example("_transactions.md", "Retrieve transaction")["transaction"]
      transaction = described_class.from_hash(hash)

      expect(transaction.id).to eq("tx_00008zIcpb1TB4yeIFXMzx")
      expect(transaction.amount).to eq(-510)
      expect(transaction.is_load).to be false
      expect(transaction.merchant).to be_a(Hash)
      expect(transaction.merchant["name"]).to eq("The De Beauvoir Deli Co.")
    end

    it "leaves merchant as the raw id String when unexpanded, as in a transactions list" do
      hash = list_transactions_response_fixture[:transactions].first.transform_keys(&:to_s)
      transaction = described_class.from_hash(hash)

      expect(transaction.merchant).to eq("merch_00008zIcpbAKe8shBxXUtl")
    end

    it "exposes fields not covered by the public docs" do
      transaction = described_class.from_hash(
        "id" => "tx_1",
        "account_id" => "acc_1",
        "user_id" => "user_1",
        "dedupe_id" => "dedupe_1",
        "decline_reason" => "INSUFFICIENT_FUNDS",
        "amount_is_pending" => true,
        "scheme" => "mastercard"
      )

      expect(transaction.account_id).to eq("acc_1")
      expect(transaction.decline_reason).to eq("INSUFFICIENT_FUNDS")
      expect(transaction.amount_is_pending).to be true
      expect(transaction.scheme).to eq("mastercard")
    end
  end
end
