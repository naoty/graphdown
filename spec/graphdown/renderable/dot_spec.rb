require "spec_helper"

class BaseRenderer < Redcarpet::Render::HTML
  include Graphdown::Renderable::DOT
end

describe Graphdown::Renderable::DOT do
  let(:markdown) { Redcarpet::Markdown.new(BaseRenderer, fenced_code_blocks: true) }
  let(:fixtures_path) { Pathname.new("spec/fixtures") }
  let(:dot_path)      { Pathname.pwd.join("sample.dot") }
  let(:graph_path)    { Pathname.pwd.join("sample.png") }

  context "when the language of block code is dot" do
    let(:content) { fixtures_path.join("sample.md").read }
    after do
      graph_path.delete if graph_path.exist?
    end

    it "generates img tag" do
      html = markdown.render(content)
      expect(html).to match /<img src="#{graph_path.to_s}"\/>/
    end

    it "generates graph image file" do
      markdown.render(content)
      expect(graph_path).to be_exist
    end
  end

  context "when the language of block code isn't dot" do
    let(:content) { fixtures_path.join("sample_without_graph.md").read }

    it "generates code tag" do
      html = markdown.render(content)
      expect(html).to match /<code>.+<\/code>/m
    end
  end
end
