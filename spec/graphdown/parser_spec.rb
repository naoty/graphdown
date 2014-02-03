require "spec_helper"

describe Graphdown::Parser do
  let(:parser) { Graphdown::Parser.new }
  let(:fixtures_path) { Pathname.new("spec/fixtures") }

  describe "#parse" do
    it "parses text into nodes" do
      content = fixtures_path.join("sample.md").read
      parser.parse(content)
      labels = parser.graph.nodes.map(&:label)
      expect(labels).to match_array ["a", "b", "c"]
    end
  end
end
