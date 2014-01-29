require "svgen"

module Graphdown
  class Graph
    def initialize
      @nodes = []
    end

    def <<(node)
      labels = @nodes.map(&:label)
      @nodes << node unless labels.include?(node.label)
    end

    def to_svg
      svg = SVGen::SVG.new do |svg|
        svg.g(fill: "none", stroke: "black") do |g|
          @nodes.each_with_index do |node, index|
            g.rect(x: 0, y: 0, width: node.width, height: node.height)
          end
        end

        svg.g("font-size" => Node::FONT_SIZE, "font-family" => Node::FONT_FAMILY, "text-anchor" => "middle") do |g|
          @nodes.each_with_index do |node, index|
            g.text(node.label, x: node.width / 2, y: Node::WORD_HEIGHT + Node::PADDING_TOP / 2)
          end
        end
      end
      svg.generate
    end
  end
end
