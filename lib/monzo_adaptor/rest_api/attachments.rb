# frozen_string_literal: true

module MonzoAdaptor
  class RestApi
    # https://docs.monzo.com/#attachments
    module Attachments
      # Obtain a temporary URL to upload an attachment file to
      #
      # @param [String] file_name The name of the file to be uploaded
      # @param [String] file_type The content type of the file
      # @param [Integer] content_length The HTTP Content-Length of the upload request, in bytes
      #
      # @return [ApiAdaptor::Response] file_url and upload_url
      def upload_attachment(file_name:, file_type:, content_length:)
        post_form(
          "#{endpoint}/attachment/upload",
          file_name: file_name, file_type: file_type, content_length: content_length
        )
      end
    end
  end
end
