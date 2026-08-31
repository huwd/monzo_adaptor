# frozen_string_literal: true

require "monzo_adaptor/resources"
require "monzo_adaptor/test_helpers/rest_api/support/support"

RSpec.describe MonzoAdaptor::Resources::Account do
  include MonzoAdaptor::TestHelpers::RestApi::Support

  describe ".from_hash" do
    it "builds from the documented account example" do
      hash = load_doc_example("_accounts.md", "List accounts")["accounts"].first
      account = described_class.from_hash(hash)

      expect(account.id).to eq("acc_00009237aqC8c5umZmrRdh")
      expect(account.description).to eq("Peter Pan's Account")
      expect(account.created).to eq("2015-11-13T12:17:42Z")
    end

    it "ignores real-world fields the docs don't mention but exposes the ones it does model" do
      account = described_class.from_hash(
        "id" => "acc_1",
        "closed" => false,
        "country_code" => "GB",
        "currency" => "GBP",
        "type" => "uk_retail",
        "sort_code" => "04-00-04",
        "account_number" => "12345678",
        "owners" => [{ "user_id" => "user_1" }]
      )

      expect(account.closed).to be false
      expect(account.country_code).to eq("GB")
      expect(account.currency).to eq("GBP")
      expect(account.type).to eq("uk_retail")
    end
  end
end
