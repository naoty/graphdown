require "spec_helper"

describe Graphdown::Renderable do
  let(:markdown) do
    renderer = Class.new(Redcarpet::Render::HTML)
    renderer.send(:include, Graphdown::Renderable)
    Redcarpet::Markdown.new(renderer)
  end
  let(:fixtures_path) { Pathname.new("./spec/fixtures") }

  context "when graph text is passed" do
    it "generates svg tag" do
      content = fixtures_path.join("sample.md").read
      html = markdown.render(content)
      expect(html).to match /<svg.+>.+<\/svg>/m
    end
  end

  context "when normal text is passed" do
    it "generates p tag" do
      content = fixtures_path.join("sample_without_graph.md").read
      html = markdown.render(content)
      expect(html).to match /<p>.+<\/p>/
    end
  end
end
