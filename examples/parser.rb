require "redcarpet"
require "graphdown"

class BaseRenderer < Redcarpet::Render::HTML
  include Graphdown::Renderable
end

markdown = Redcarpet::Markdown.new(BaseRenderer, fenced_code_blocks: true)
File.open("sample.md", "rb") do |file|
  content = file.read
  html = markdown.render(content)
  File.open("sample.html", "wb") { |file| file.write(html) }
end
