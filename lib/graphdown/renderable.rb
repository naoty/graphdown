require "cgi"

module Graphdown
  module Renderable
    def paragraph(text)
      if text =~ /^\s?\[.+\]\s?$/
        parser = Parser.new
        unescaped_text = CGI.unescape_html(text)
        unescaped_text.split($/).each { |line| parser.parse(line) }
        parser.output
      else
        %(<p>#{text}</p>)
      end
    end
  end
end
