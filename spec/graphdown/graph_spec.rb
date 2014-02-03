require "spec_helper"

describe Graphdown::Graph do
  let(:fixtures_path) { Pathname.new("spec/fixtures") }
  let(:graph) { Graphdown::Graph.new }
  let(:a) { Graphdown::Node.new("a") }
  let(:b) { Graphdown::Node.new("b") }
  let(:c) { Graphdown::Node.new("c") }

  before do
    a.connect(b)
    b.connect(c)
    graph << a
    graph << b
    graph << c
  end

  describe "#find_node_by_label" do
    it "finds node" do
      node = graph.find_node_by_label("a")
      expect(node).to equal a
    end
  end

  describe "#to_svg" do
    it "generates svg" do
      expect(graph.to_svg).to eq fixtures_path.join("sample.svg").read
    end
  end

  describe "#layered_nodes" do
    it "returns layered nodes" do
      expect(graph.layered_nodes).to match_array [[a], [b], [c]]
    end
  end
end
