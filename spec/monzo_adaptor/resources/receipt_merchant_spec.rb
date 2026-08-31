# frozen_string_literal: true

require "monzo_adaptor/resources"

RSpec.describe MonzoAdaptor::Resources::ReceiptMerchant do
  describe ".from_hash" do
    it "builds from the documented receipt merchant fields" do
      merchant = described_class.from_hash(
        "name" => "Bourgee",
        "online" => false,
        "phone" => "01277225069",
        "email" => "info@bourgee.com",
        "store_name" => "Brentwood",
        "store_address" => "30 High St, Brentwood CM14 4AJ",
        "store_postcode" => "CM14 4AJ"
      )

      expect(merchant.name).to eq("Bourgee")
      expect(merchant.online).to be false
      expect(merchant.phone).to eq("01277225069")
      expect(merchant.email).to eq("info@bourgee.com")
      expect(merchant.store_name).to eq("Brentwood")
      expect(merchant.store_address).to eq("30 High St, Brentwood CM14 4AJ")
      expect(merchant.store_postcode).to eq("CM14 4AJ")
    end

    it "defaults fields missing from the hash to nil" do
      merchant = described_class.from_hash("name" => "Bourgee")
      expect(merchant.phone).to be_nil
    end
  end
end
