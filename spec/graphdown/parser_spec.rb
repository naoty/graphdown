require "spec_helper"

describe Graphdown::Parser do
  let(:parser) { Graphdown::Parser.new }

  describe "#parse" do
    let(:content) { "[a] -> [b] <-> [c]" }

    before do
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

    context "when a node group is given" do
      let(:content) { "[a] -> [b], [c], [d] -> [e]" }

      it "parses text into nodes" do
        labels = parser.graph.nodes.map(&:label)
        expect(labels).to eq ["a", "b", "c", "d", "e"]
      end
    end
  end
end
