# frozen_string_literal: true

module MonzoAdaptor
  class RestApi
    # https://docs.monzo.com/#feed-items
    module FeedItems
      # Create a new item on the user's feed
      #
      # Currently "basic" is the only supported type, which requires
      # params[:title] and params[:image_url]; params[:body],
      # params[:background_color], params[:title_color] and
      # params[:body_color] are optional.
      #
      # @param [String] account_id The account to create a feed item for
      # @param [Hash] params Type-specific display parameters
      # @param [String] type Feed item type (only "basic" is currently supported)
      # @param [String, nil] url Opened when the feed item is tapped
      #
      # @return [ApiAdaptor::Response] an empty response on success
      def create_feed_item(account_id:, params:, type: "basic", url: nil)
        form_params = { account_id: account_id, type: type, params: params }
        form_params[:url] = url if url
        post_form("#{endpoint}/feed", form_params)
      end
    end
  end
end
