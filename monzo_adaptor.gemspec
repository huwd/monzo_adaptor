# frozen_string_literal: true

require_relative "lib/monzo_adaptor/version"

Gem::Specification.new do |spec|
  spec.name = "monzo_adaptor"
  spec.version = MonzoAdaptor::VERSION
  spec.authors = ["Huw Diprose"]
  spec.email = ["mail@huwdiprose.co.uk"]

  spec.summary = "An API wrapper to interact with the Monzo API"
  spec.description = "Use the Monzo REST and OAuth2 APIs from Ruby"
  spec.homepage = "https://github.com/huwd/monzo_adaptor"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/huwd/monzo_adaptor"
  spec.metadata["changelog_uri"] = "https://github.com/huwd/monzo_adaptor/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "api_adaptor", ">= 1.0.0"

  spec.metadata["rubygems_mfa_required"] = "true"
end
