module Graphdown
  class Parser
    def initialize
      @graph = Graph.new
    end

    def parse(text)
      tokens = text.split(/\s+/)
      tokens.each_with_index do |token, index|
        next unless index > 0 && index % 2 == 0
        origin = Node.new(tokens[index - 2].gsub(/\[(.+)\]/) { $1 })
        target = Node.new(tokens[index].gsub(/\[(.+)\]/) { $1 })
        case tokens[index - 1]
        when "->"
          origin.connect(target)
        when "<->"
          origin.connect(target, :two_way)
        end
        @graph << origin
        @graph << target
      end
    end

    def output
      @graph.to_svg
    end
  end
end
