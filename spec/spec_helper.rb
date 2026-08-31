# frozen_string_literal: true

require "simplecov"

SimpleCov.enable_coverage :branch
SimpleCov.start do
  add_filter "/spec/"

  minimum_coverage line: 80, branch: 75
end

require "monzo_adaptor"
require "webmock/rspec"

if ENV["CONTRACT"] == "1"
  WebMock.disable_net_connect!(allow: "raw.githubusercontent.com")
else
  WebMock.disable_net_connect!
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Contract specs hit the real monzo/docs source on GitHub to check our
  # vendored fixtures haven't drifted. They're excluded by default, and
  # never run in CI — see spec/contract/README.md.
  config.filter_run_excluding contract: true unless ENV["CONTRACT"] == "1"
end
