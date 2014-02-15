require "spec_helper"

describe Graphdown::Parser do
  let(:parser) { Graphdown::Parser.new }
  let(:fixtures_path) { Pathname.new("spec/fixtures") }

  describe "#parse" do
    before do
      content = fixtures_path.join("sample.md").read
      parser.parse(content)
    end

    it "parses text into nodes" do
      labels = parser.graph.nodes.map(&:label)
      expect(labels).to eq ["a", "b", "c"]
    end

    it "parses arrows into edges" do
      edges = parser.graph.nodes.map(&:child_edges).flatten
      directions = edges.map(&:direction)
      expect(directions).to eq [:forward, :two_way]
    end
  end
end
