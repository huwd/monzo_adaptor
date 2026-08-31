# frozen_string_literal: true

require "monzo_adaptor/resources/from_hash"

RSpec.describe MonzoAdaptor::Resources::FromHash do
  let(:klass) do
    Data.define(:a, :b) do
      extend MonzoAdaptor::Resources::FromHash
    end
  end

  describe ".from_hash" do
    it "builds an instance from a Hash with symbol keys" do
      instance = klass.from_hash(a: 1, b: 2)
      expect(instance).to eq(klass.new(a: 1, b: 2))
    end

    it "builds an instance from a Hash with string keys" do
      instance = klass.from_hash("a" => 1, "b" => 2)
      expect(instance).to eq(klass.new(a: 1, b: 2))
    end

    it "defaults members missing from the hash to nil" do
      instance = klass.from_hash(a: 1)
      expect(instance.b).to be_nil
    end

    it "ignores hash keys the class doesn't define" do
      instance = klass.from_hash(a: 1, b: 2, unexpected: "ignored")
      expect(instance).to eq(klass.new(a: 1, b: 2))
    end

    it "doesn't mistake a falsy value for a missing key" do
      instance = klass.from_hash(a: false, b: 2)
      expect(instance.a).to be false
    end
  end
end
