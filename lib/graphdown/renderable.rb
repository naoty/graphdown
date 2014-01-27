module Graphdown
  module Renderable
    def paragraph(text)
      if text =~ /^\s?\[.+\]\s?$/
        parser = Parser.new
        text.split($/).each { |line| parser.parse(line) }
        parser.output
      else
        %(<p>#{text}</p>)
      end
    end
  end
end
