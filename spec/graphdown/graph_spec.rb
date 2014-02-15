require "spec_helper"

describe Graphdown::Graph do
  let(:graph) { Graphdown::Graph.new }
  let(:a) { Graphdown::Node.new("a") }
  let(:b) { Graphdown::Node.new("b") }
  let(:c) { Graphdown::Node.new("c") }
  let(:d) { Graphdown::Node.new("d") }
  let(:e) { Graphdown::Node.new("e") }

  before do
    [a, b, c, d, e].each { |node| graph << node }
  end

  describe "#find_node_by_label" do
    it "finds node" do
      node = graph.find_node_by_label("a")
      expect(node).to equal a
    end
  end

  describe "#layered_nodes" do
    it "returns layered nodes" do
      e.connect(d)
      e.connect(c)
      d.connect(b)
      b.connect(a)
      graph.layer_nodes
      expect(graph.layered_nodes).to match_array [[e], [d, c], [b], [a]]
    end
  end
end
