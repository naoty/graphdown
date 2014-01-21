require "spec_helper"

class BaseRenderer < Redcarpet::Render::HTML
  include Graphdown::Renderable
end

describe Graphdown::Renderable do
  let(:markdown) { Redcarpet::Markdown.new(BaseRenderer, fenced_code_blocks: true) }
  let(:fixtures_path) { Pathname.new("spec/fixtures") }
  let(:graph_path)    { fixtures_path.join("sample.png") }

  context "when the language of block code is dot" do
    let(:content) { fixtures_path.join("sample.md").read }

    it "generates img tag" do
      html = markdown.render(content)
      expect(html).to match /<img href="sample\.png"\/>/
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
