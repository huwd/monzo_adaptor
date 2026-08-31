# frozen_string_literal: true

require "monzo_adaptor/rest_api"
require "monzo_adaptor/test_helpers/rest_api"

RSpec.describe MonzoAdaptor::RestApi::FeedItems do
  include MonzoAdaptor::TestHelpers::RestApi

  let(:endpoint) { "https://api.test.monzo.com" }
  let(:api_client) { MonzoAdaptor::RestApi.new(endpoint, bearer_token: "access_token") }
  let(:account_id) { "acc_00009237aqC8c5umZmrRdh" }

  describe "#create_feed_item" do
    it "creates a basic feed item, form-encoding the request" do
      stub_create_feed_item
      response = api_client.create_feed_item(
        account_id: account_id,
        params: { title: "My custom item", image_url: "https://example.com/image.png" },
        url: "https://example.com/a_page.html"
      )

      expect(response.parsed_content).to eq({})
      expect(WebMock).to have_requested(:post, "#{endpoint}/feed")
        .with(
          body: {
            "account_id" => account_id,
            "type" => "basic",
            "url" => "https://example.com/a_page.html",
            "params" => { "title" => "My custom item", "image_url" => "https://example.com/image.png" }
          },
          headers: { "Content-Type" => "application/x-www-form-urlencoded" }
        )
    end

    it "omits url when not given" do
      stub_create_feed_item
      api_client.create_feed_item(account_id: account_id, params: { title: "My custom item" })

      expect(WebMock).to have_requested(:post, "#{endpoint}/feed")
        .with(body: { "account_id" => account_id, "type" => "basic", "params" => { "title" => "My custom item" } })
    end
  end
end
