# frozen_string_literal: true

require_relative "errors"

module MonzoAdaptor
  # Monzo REST API client
  #
  # @see https://docs.monzo.com/
  class RestApi < ApiAdaptor::Base
    require_relative "rest_api/whoami"
    include MonzoAdaptor::RestApi::Whoami

    # HTTP status -> Monzo-flavoured exception, layered on top of the
    # generic status-code exceptions ApiAdaptor::Base's HTTP methods
    # already raise.
    TRANSLATED_ERRORS = {
      ApiAdaptor::HTTPForbidden => MonzoAdaptor::InsufficientPermissionsError,
      ApiAdaptor::HTTPTooManyRequests => MonzoAdaptor::RateLimitError
    }.freeze

    %i[get_json post_json put_json patch_json delete_json].each do |http_method|
      define_method(http_method) do |*args, **kwargs, &block|
        super(*args, **kwargs, &block)
      rescue *TRANSLATED_ERRORS.keys => e
        raise TRANSLATED_ERRORS.fetch(e.class).new(e.code, e.message, e.error_details, e.http_body)
      end
    end
  end
end
