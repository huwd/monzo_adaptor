# frozen_string_literal: true

require_relative "support/support"

module MonzoAdaptor
  module TestHelpers
    module RestApi
      # WebMock stubs for the Monzo /feed endpoint
      module FeedItems
        include MonzoAdaptor::TestHelpers::RestApi::Support

        ###############
        # POST /feed
        ###############

        # Stub a successful feed item creation
        #
        # @param response_body [Hash, nil] Optional response body
        #
        # @return [WebMock::RequestStub]
        def stub_create_feed_item(response_body: nil)
          stub_rest_api_request(
            :post,
            "/feed",
            response_body: response_body || load_doc_example("_feed_items.md", "Create feed item")
          )
        end
      end
    end
  end
end
