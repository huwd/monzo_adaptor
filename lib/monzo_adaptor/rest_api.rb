# frozen_string_literal: true

require "json"
require "rest-client"
require_relative "errors"

module MonzoAdaptor
  # Monzo REST API client
  #
  # @see https://docs.monzo.com/
  class RestApi < ApiAdaptor::Base
    include ApiAdaptor::ExceptionHandling

    require_relative "rest_api/whoami"
    require_relative "rest_api/accounts"
    require_relative "rest_api/balance"
    require_relative "rest_api/pots"
    require_relative "rest_api/transactions"
    require_relative "rest_api/feed_items"
    include MonzoAdaptor::RestApi::Whoami
    include MonzoAdaptor::RestApi::Accounts
    include MonzoAdaptor::RestApi::Balance
    include MonzoAdaptor::RestApi::Pots
    include MonzoAdaptor::RestApi::Transactions
    include MonzoAdaptor::RestApi::FeedItems

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
        raise self.class.translate_error(e)
      end
    end

    # Translates a generic ApiAdaptor HTTP error into its Monzo-flavoured
    # equivalent, if one exists; otherwise returns it unchanged.
    #
    # @api private
    def self.translate_error(error)
      translated_class = TRANSLATED_ERRORS[error.class]
      return error unless translated_class

      translated_class.new(error.code, error.message, error.error_details, error.http_body)
    end

    private

    # Monzo's write endpoints (pots deposit/withdraw, feed items,
    # attachments, ...) require application/x-www-form-urlencoded bodies,
    # not JSON — ApiAdaptor::JSONClient can only send JSON, so these bypass
    # it and use RestClient directly, while still returning an
    # ApiAdaptor::Response and raising the same (Monzo-translated)
    # exceptions as the JSON methods.
    def put_form(url, params)
      form_request(:put, url, params)
    end

    # @see #put_form
    def post_form(url, params)
      form_request(:post, url, params)
    end

    # @see #put_form
    def patch_form(url, params)
      form_request(:patch, url, params)
    end

    def form_request(method, url, params)
      ApiAdaptor::Response.new(RestClient.send(method, url, params))
    rescue RestClient::ExceptionWithResponse => e
      details = begin
        JSON.parse(e.http_body)
      rescue JSON::ParserError, TypeError
        nil
      end
      raise self.class.translate_error(build_specific_http_error(e, url, details))
    end
  end
end
