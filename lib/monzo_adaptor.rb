# frozen_string_literal: true

require "api_adaptor"

require_relative "monzo_adaptor/version"

module MonzoAdaptor
  # Base error class for MonzoAdaptor exceptions
  class Error < StandardError; end
end

require_relative "monzo_adaptor/errors"
require_relative "monzo_adaptor/rest_api"
require_relative "monzo_adaptor/oauth"
