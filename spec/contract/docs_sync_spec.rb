# frozen_string_literal: true

require "net/http"
require "uri"

BASE_MONZO_DOCS_URL = "https://raw.githubusercontent.com/monzo/docs/master/source/includes"
MONZO_DOCS_FIXTURES_DIR = File.join("spec", "fixtures", "monzo_docs")

# Checks that the vendored copies of monzo/docs' source/includes/*.md files
# under spec/fixtures/monzo_docs haven't drifted from the live source. This
# is the closest thing this gem has to a "sandbox" check, since Monzo
# publishes no sandbox environment (see CLAUDE.md). It hits the network, so
# it's excluded by default and never run in CI — run it manually with:
#
#   CONTRACT=1 bundle exec rspec spec/contract
#
# A failure here doesn't mean the gem is broken — it means Monzo's published
# docs have changed. Run bin/refresh-monzo-docs, review the diff, and update
# any stub_* helpers or specs the change affects.
RSpec.describe "monzo/docs fixtures", :contract do
  Dir.glob(File.join(MONZO_DOCS_FIXTURES_DIR, "*.md")).each do |path|
    it "matches the live monzo/docs source for #{File.basename(path)}" do
      live = Net::HTTP.get(URI("#{BASE_MONZO_DOCS_URL}/#{File.basename(path)}"))
                      .force_encoding(Encoding::UTF_8)
      vendored = File.read(path, encoding: Encoding::UTF_8)

      expect(vendored).to eq(live), "#{File.basename(path)} has drifted from monzo/docs — " \
                                    "run bin/refresh-monzo-docs and review the diff"
    end
  end
end
