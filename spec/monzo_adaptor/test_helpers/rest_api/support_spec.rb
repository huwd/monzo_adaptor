# frozen_string_literal: true

require "monzo_adaptor/test_helpers/rest_api/support/support"

RSpec.describe MonzoAdaptor::TestHelpers::RestApi::Support do
  let(:helper) { Class.new { include MonzoAdaptor::TestHelpers::RestApi::Support }.new }

  describe "#load_doc_example" do
    it "loads the JSON example from under a top-level heading" do
      example = helper.load_doc_example("_authentication.md", "Authenticating requests")

      expect(example).to eq(
        "authenticated" => true,
        "client_id" => "client_id",
        "user_id" => "user_id"
      )
    end

    it "loads the JSON example from under a nested heading" do
      example = helper.load_doc_example("_authentication.md", "Exchange the authorization code")

      expect(example).to include("access_token" => "access_token", "token_type" => "Bearer")
    end

    it "raises when the file has no section with that heading" do
      expect do
        helper.load_doc_example("_authentication.md", "Nonexistent heading")
      end.to raise_error(/No section/)
    end

    it "raises when the section has no JSON example" do
      expect do
        helper.load_doc_example("_authentication.md", "Log Out")
      end.to raise_error(/No JSON example/)
    end
  end
end
