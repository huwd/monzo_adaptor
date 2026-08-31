# frozen_string_literal: true

require_relative "support/support"

module MonzoAdaptor
  module TestHelpers
    module RestApi
      # WebMock stubs for the Monzo /attachment endpoints
      module Attachments
        include MonzoAdaptor::TestHelpers::RestApi::Support

        ###############################
        # POST /attachment/upload
        ###############################

        # Stub a successful attachment upload URL request
        #
        # @param response_body [Hash, nil] Optional response body
        #
        # @return [WebMock::RequestStub]
        def stub_upload_attachment(response_body: nil)
          stub_rest_api_request(
            :post,
            "/attachment/upload",
            response_body: response_body || load_doc_example("_attachments.md", "Upload attachment")
          )
        end

        ###############################
        # POST /attachment/register
        ###############################

        # Stub a successful attachment registration
        #
        # @param response_body [Hash, nil] Optional response body
        #
        # @return [WebMock::RequestStub]
        def stub_register_attachment(response_body: nil)
          stub_rest_api_request(
            :post,
            "/attachment/register",
            response_body: response_body || load_doc_example("_attachments.md", "Register attachment")
          )
        end
      end
    end
  end
end
