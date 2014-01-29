require "spec_helper"

describe Graphdown::Node do
  let(:a) { Graphdown::Node.new("a") }
  let(:b) { Graphdown::Node.new("b") }
  let(:c) { Graphdown::Node.new("c") }

  describe "#connect" do
    it "connects node forward" do
      a.connect(b)
      expect(a.children).to be_include(b)
    end

    it "connects node backward" do
      a.connect(b, :backward)
      expect(a.parents).to be_include(b)
    end

    it "prevents closed path" do
      a.connect(b)
      b.connect(c)
      c.connect(a)
      expect(a.ancestors).to match_array []
      expect(a.descendants).to match_array [b, c, c]
    end
  end

  describe "#ancestors" do
    it "returns parents of parents" do
      a.connect(b)
      b.connect(c)
      expect(c.ancestors).to match_array [a, b]
    end
  end
end
