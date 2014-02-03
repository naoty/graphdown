module Graphdown
  class Parser
    attr_reader :graph

    def initialize
      @graph = Graph.new
    end

    def parse(text)
      tokens = text.split(/\s+/)
      tokens.each_with_index do |token, index|
        next unless index > 0 && index % 2 == 0

        origin_label = tokens[index - 2].gsub(/\[(.+)\]/) { $1 }
        origin = @graph.find_node_by_label(origin_label) || Node.new(origin_label)

        target_label = tokens[index].gsub(/\[(.+)\]/) { $1 }
        target = @graph.find_node_by_label(target_label) || Node.new(target_label)

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
