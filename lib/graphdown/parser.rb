module Graphdown
  class Parser
    attr_reader :graph

    def initialize
      @graph = Graph.new
    end

    def parse(text)
      tokens = text.split(/(?<=[\]>])\s+/)
      2.step(tokens.size, 2) do |n|
        # origins
        origin_labels = tokens[n - 2].scan(/(?<=\[).+?(?=\])/)
        origins = origin_labels.map do |label|
          @graph.find_node_by_label(label) || Node.new(label)
        end

        # targets
        target_labels = tokens[n].scan(/(?<=\[).+?(?=\])/)
        targets = target_labels.map do |label|
          @graph.find_node_by_label(label) || Node.new(label)
        end

        # edges
        direction = (tokens[n - 1] == "<->") ? :two_way : :forward
        origins.each do |origin|
          @graph << origin
          targets.each do |target|
            origin.connect(target, direction)
            @graph << target
          end
        end
      end
    end

    def output
      @graph.layer_nodes
      @graph.layout_nodes
      @graph.layout_edges
      @graph.to_svg
    end
  end
end
