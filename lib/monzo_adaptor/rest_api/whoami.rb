# frozen_string_literal: true

module MonzoAdaptor
  class RestApi
    # https://docs.monzo.com/#authenticating-requests
    module Whoami
      # Check the validity of the current access token
      #
      # @return [Hash] authentication status, client_id and user_id
      def whoami
        get_json("#{endpoint}/ping/whoami")
      end
    end
  end
end
