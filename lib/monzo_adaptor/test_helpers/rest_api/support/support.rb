# frozen_string_literal: true

require "json"

module MonzoAdaptor
  module TestHelpers
    module RestApi
      # Helpers for loading example fixtures vendored from github.com/monzo/docs
      module Support
        # Directory containing vendored copies of monzo/docs' source/includes/*.md
        FIXTURES_PATH = File.join("spec", "fixtures", "monzo_docs")

        # Load the JSON example for a documented endpoint from a vendored
        # Monzo docs markdown file.
        #
        # @param file [String] filename under spec/fixtures/monzo_docs, e.g. "_balance.md"
        # @param heading [String] the exact heading text the example sits under, e.g. "Read balance"
        #
        # @return [Hash, Array] the parsed JSON example
        def load_doc_example(file, heading)
          json = doc_section(file, heading)[:json]
          raise "No JSON example under '#{heading}' in #{file}" unless json

          JSON.parse(json)
        end

        # Extract the shell and JSON fenced code blocks from under a heading
        # in a vendored Monzo docs markdown file.
        #
        # @param file [String] filename under spec/fixtures/monzo_docs
        # @param heading [String] the exact heading text
        #
        # @return [Hash{Symbol => String, nil}] :shell and :json fenced block contents
        #
        # @api private
        def doc_section(file, heading)
          content = File.read(File.join(FIXTURES_PATH, file))
          section = content.split(/^#+ +/).find { |s| s.start_with?(heading) }
          raise "No section '#{heading}' found in #{file}" unless section

          {
            shell: section[/```shell\n(.*?)\n```/m, 1],
            json: section[/```json\n(.*?)\n```/m, 1]
          }
        end
      end
    end
  end
end
