# frozen_string_literal: true

require "monzo_adaptor/resources"
require "monzo_adaptor/test_helpers/rest_api/support/support"

RSpec.describe MonzoAdaptor::Resources::Pot do
  include MonzoAdaptor::TestHelpers::RestApi::Support

  describe ".from_hash" do
    it "builds from the documented pot example" do
      hash = load_doc_example("_pots.md", "List pots")["pots"].first
      pot = described_class.from_hash(hash)

      expect(pot.id).to eq("pot_0000778xxfgh4iu8z83nWb")
      expect(pot.name).to eq("Savings")
      expect(pot.balance).to eq(133_700)
      expect(pot.deleted).to be false
    end

    it "exposes fields not covered by the public docs" do
      pot = described_class.from_hash(
        "id" => "pot_1",
        "product_id" => "core_pot",
        "current_account_id" => "acc_1",
        "cover_image_url" => "https://example.com/cover.png",
        "isa_wrapper" => "",
        "charity_id" => "",
        "goal_amount" => 100_000,
        "locked" => false,
        "is_tax_pot" => false,
        "round_up" => true,
        "round_up_multiplier" => 2,
        "available_for_bills" => false,
        "assigned_permissions" => [{ "user_id" => "user_1", "permission_level" => "manager" }]
      )

      expect(pot.product_id).to eq("core_pot")
      expect(pot.round_up).to be true
      expect(pot.round_up_multiplier).to eq(2)
      expect(pot.assigned_permissions).to eq([{ "user_id" => "user_1", "permission_level" => "manager" }])
    end
  end
end
