# frozen_string_literal: true

require "monzo_adaptor/rest_api"
require "monzo_adaptor/test_helpers/rest_api"

RSpec.describe MonzoAdaptor::RestApi::Attachments do
  include MonzoAdaptor::TestHelpers::RestApi

  let(:endpoint) { "https://api.test.monzo.com" }
  let(:api_client) { MonzoAdaptor::RestApi.new(endpoint, bearer_token: "access_token") }

  describe "#upload_attachment" do
    it "requests a temporary upload URL, form-encoding the request" do
      stub_upload_attachment
      response = api_client.upload_attachment(file_name: "foo.png", file_type: "image/png", content_length: 12_345)

      expect(response.parsed_content).to include("file_url", "upload_url")
      expect(WebMock).to have_requested(:post, "#{endpoint}/attachment/upload")
        .with(
          body: { "file_name" => "foo.png", "file_type" => "image/png", "content_length" => "12345" },
          headers: { "Content-Type" => "application/x-www-form-urlencoded" }
        )
    end
  end
end
