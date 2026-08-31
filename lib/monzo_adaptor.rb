# frozen_string_literal: true

require "api_adaptor"

require_relative "monzo_adaptor/version"

module MonzoAdaptor
  # Base error class for MonzoAdaptor exceptions
  class Error < StandardError; end
end
