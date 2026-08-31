# frozen_string_literal: true

require "monzo_adaptor/resources"
require "monzo_adaptor/test_helpers/rest_api/support/support"

RSpec.describe MonzoAdaptor::Resources::Merchant do
  include MonzoAdaptor::TestHelpers::RestApi::Support

  describe ".from_hash" do
    it "builds from the documented merchant example, leaving address as the raw Hash" do
      hash = load_doc_example("_transactions.md", "Retrieve transaction")["transaction"]["merchant"]
      merchant = described_class.from_hash(hash)

      expect(merchant.id).to eq("merch_00008zIcpbAKe8shBxXUtl")
      expect(merchant.name).to eq("The De Beauvoir Deli Co.")
      expect(merchant.category).to eq("eating_out")
      expect(merchant.address).to include("city" => "London")
    end

    it "exposes fields not covered by the public docs" do
      merchant = described_class.from_hash(
        "id" => "merch_1",
        "online" => true,
        "disable_feedback" => false
      )

      expect(merchant.online).to be true
      expect(merchant.disable_feedback).to be false
    end
  end
end
