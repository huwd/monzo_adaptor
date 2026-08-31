# frozen_string_literal: true

require "api_adaptor"

module MonzoAdaptor
  # Shared behaviour for Monzo-flavoured HTTP error subclasses: exposes the
  # `code`/`message` fields Monzo's JSON error bodies conventionally carry,
  # parsed into ApiAdaptor::HTTPErrorResponse#error_details.
  #
  # There is no documented enum of values for `code` on 403/429 responses,
  # so consumers should treat #monzo_code as informational rather than
  # match against a fixed list.
  module MonzoErrorDetails
    # @return [String, nil] the value of the body's "code" field, if present
    def monzo_code
      error_details && error_details["code"]
    end

    # @return [String, nil] the value of the body's "message" field, if present
    def monzo_message
      error_details && error_details["message"]
    end
  end

  # Raised when Monzo returns a 403 for a request that's authenticated but
  # lacks permission — most commonly because the user hasn't yet approved
  # access to their data via Strong Customer Authentication in the app.
  #
  # @see https://docs.monzo.com/#errors
  class InsufficientPermissionsError < ApiAdaptor::HTTPForbidden
    include MonzoErrorDetails
  end

  # Raised when Monzo returns a 429 because the application is exceeding
  # its rate limit.
  #
  # @see https://docs.monzo.com/#errors
  class RateLimitError < ApiAdaptor::HTTPTooManyRequests
    include MonzoErrorDetails
  end
end
