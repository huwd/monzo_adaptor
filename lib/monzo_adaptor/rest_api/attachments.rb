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

      # Register an uploaded (or externally-hosted) attachment against a transaction
      #
      # @param [String] external_id The id of the transaction to associate the attachment with
      # @param [String] file_url The URL of the uploaded attachment
      # @param [String] file_type The content type of the attachment
      #
      # @return [ApiAdaptor::Response] the registered attachment
      def register_attachment(external_id:, file_url:, file_type:)
        post_form(
          "#{endpoint}/attachment/register",
          external_id: external_id, file_url: file_url, file_type: file_type
        )
      end

      # Remove an attachment
      #
      # @param [String] id The id of the attachment to deregister
      #
      # @return [ApiAdaptor::Response] an empty response on success
      def deregister_attachment(id)
        post_form("#{endpoint}/attachment/deregister", id: id)
      end
    end
  end
end
