# frozen_string_literal: true

require "monzo_adaptor/resources"

RSpec.describe MonzoAdaptor::Resources::Metadatum do
  describe ".from_hash" do
    it "builds from a typical transaction metadata Hash" do
      metadatum = described_class.from_hash(
        "notes" => "Lunch with Sam",
        "trigger" => "manual",
        "mcc" => "5812",
        "insertion" => "manual"
      )

      expect(metadatum.notes).to eq("Lunch with Sam")
      expect(metadatum.trigger).to eq("manual")
      expect(metadatum.mcc).to eq("5812")
    end

    it "defaults an empty metadata Hash to all-nil fields" do
      metadatum = described_class.from_hash({})
      expect(metadatum.notes).to be_nil
    end

    it "exposes a representative sample of the ~80 fields Monzo isn't documented to send" do
      metadatum = described_class.from_hash(
        "faster_payment" => "true",
        "is_topup" => "true",
        "pot_id" => "pot_123",
        "subscription_type" => "premium",
        "mastercard_approval_type" => "0100"
      )

      expect(metadatum.faster_payment).to eq("true")
      expect(metadatum.is_topup).to eq("true")
      expect(metadatum.pot_id).to eq("pot_123")
      expect(metadatum.subscription_type).to eq("premium")
      expect(metadatum.mastercard_approval_type).to eq("0100")
    end
  end
end
