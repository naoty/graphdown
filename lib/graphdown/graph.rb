require "svgen"

module Graphdown
  class Graph
    attr_reader :nodes

    PADDING = 10

    def initialize
      @nodes = []
    end

    def <<(node)
      labels = @nodes.map(&:label)
      @nodes << node unless labels.include?(node.label)
    end

    def find_node_by_label(label)
      (@nodes || []).select { |node| node.label == label }.first
    end

    def to_svg
      svg = SVGen::SVG.new do |svg|
        layer_widths = []
        svg.g(fill: "none", stroke: "black") do |g|
          layer_offset = PADDING
          layered_nodes.each_with_index do |nodes, index|
            node_offset = PADDING
            nodes.each_with_index do |node, index|
              g.rect(x: node_offset, y: layer_offset, width: node.width, height: node.height)
              node_offset += node.width + Node::MARGIN_RIGHT
            end
            layer_offset += nodes.map(&:height).max + Node::MARGIN_BOTTOM
            layer_widths << node_offset + PADDING
          end
          svg.width = layer_widths.max
          svg.height = layer_offset + PADDING
        end

        svg.g("font-size" => Node::FONT_SIZE, "font-family" => Node::FONT_FAMILY, "text-anchor" => "middle") do |g|
          layer_offset = PADDING
          layered_nodes.each_with_index do |nodes, index|
            node_offset = PADDING
            nodes.each_with_index do |node, index|
              g.text(node.label, x: node_offset + node.width / 2, y: layer_offset + Node::WORD_HEIGHT + Node::PADDING_TOP / 2)
              node_offset += node.width + Node::MARGIN_RIGHT
            end
            layer_offset += nodes.map(&:height).max + Node::MARGIN_BOTTOM
          end
        end
      end
      svg.generate
    end

    def layered_nodes
      @layered_nodes ||= @nodes.group_by { |node| node.ancestors.count }.values
    end
  end
end
