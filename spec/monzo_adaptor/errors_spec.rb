# frozen_string_literal: true

require "monzo_adaptor/errors"

RSpec.describe MonzoAdaptor::MonzoErrorDetails do
  describe MonzoAdaptor::InsufficientPermissionsError do
    it "is a kind of ApiAdaptor::HTTPForbidden" do
      expect(described_class.ancestors).to include(ApiAdaptor::HTTPForbidden)
    end

    describe "#monzo_code and #monzo_message" do
      it "exposes the parsed body's code and message" do
        error = described_class.new(403, "boom", { "code" => "forbidden.verification_required", "message" => "boom" }, "{}")

        expect(error.monzo_code).to eq("forbidden.verification_required")
        expect(error.monzo_message).to eq("boom")
      end

      it "is nil-safe when there is no parsed body" do
        error = described_class.new(403, "boom", nil, nil)

        expect(error.monzo_code).to be_nil
        expect(error.monzo_message).to be_nil
      end
    end
  end

  describe MonzoAdaptor::RateLimitError do
    it "is a kind of ApiAdaptor::HTTPTooManyRequests" do
      expect(described_class.ancestors).to include(ApiAdaptor::HTTPTooManyRequests)
    end

    it "exposes the parsed body's code and message" do
      error = described_class.new(429, "slow down", { "code" => "too_many_requests", "message" => "slow down" }, "{}")

      expect(error.monzo_code).to eq("too_many_requests")
      expect(error.monzo_message).to eq("slow down")
    end
  end
end
