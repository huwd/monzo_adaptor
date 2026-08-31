# frozen_string_literal: true

require "monzo_adaptor/rest_api"
require "monzo_adaptor/test_helpers/rest_api"

RSpec.describe MonzoAdaptor::RestApi::Webhooks do
  include MonzoAdaptor::TestHelpers::RestApi

  let(:endpoint) { "https://api.test.monzo.com" }
  let(:api_client) { MonzoAdaptor::RestApi.new(endpoint, bearer_token: "access_token") }
  let(:account_id) { "acc_000091yf79yMwNaZHhHGzp" }

  describe "#register_webhook" do
    it "registers a webhook, form-encoding the request" do
      stub_register_webhook
      response = api_client.register_webhook(account_id: account_id, url: "http://example.com")

      expect(response.parsed_content["webhook"]).to include("url" => "http://example.com")
      expect(WebMock).to have_requested(:post, "#{endpoint}/webhooks")
        .with(
          body: { "account_id" => account_id, "url" => "http://example.com" },
          headers: { "Content-Type" => "application/x-www-form-urlencoded" }
        )
    end
  end

  describe "#get_webhooks" do
    it "returns the webhooks registered on the given account" do
      stub_get_webhooks(account_id)
      webhooks = api_client.get_webhooks(account_id).parsed_content["webhooks"]

      expect(webhooks.map { |w| w["id"] }).to eq(%w[webhook_000091yhhOmrXQaVZ1Irsv webhook_000091yhhzvJSxLYGAceC9])
    end
  end

  describe "#delete_webhook" do
    it "deletes the given webhook" do
      stub_delete_webhook("webhook_000091yhhOmrXQaVZ1Irsv")
      expect(api_client.delete_webhook("webhook_000091yhhOmrXQaVZ1Irsv").parsed_content).to eq({})
    end
  end
end
