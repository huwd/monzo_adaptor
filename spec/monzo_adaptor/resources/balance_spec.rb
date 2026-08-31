# frozen_string_literal: true

require "monzo_adaptor/resources"
require "monzo_adaptor/test_helpers/rest_api/support/support"

RSpec.describe MonzoAdaptor::Resources::Balance do
  include MonzoAdaptor::TestHelpers::RestApi::Support

  describe ".from_hash" do
    it "builds from the documented balance example" do
      hash = load_doc_example("_balance.md", "Read balance")
      balance = described_class.from_hash(hash)

      expect(balance.balance).to eq(5000)
      expect(balance.total_balance).to eq(6000)
      expect(balance.currency).to eq("GBP")
      expect(balance.spend_today).to eq(0)
    end

    it "exposes fields not covered by the public docs" do
      balance = described_class.from_hash(
        "balance" => 5000,
        "local_currency" => "USD",
        "local_spend" => [{ "currency" => "USD", "spend_today" => 0 }],
        "local_exchange_rate" => 1.3,
        "balance_including_flexible_savings" => 5500
      )

      expect(balance.local_currency).to eq("USD")
      expect(balance.local_exchange_rate).to eq(1.3)
      expect(balance.balance_including_flexible_savings).to eq(5500)
    end
  end
end
