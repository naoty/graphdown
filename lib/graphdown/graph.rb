require "svgen"

module Graphdown
  class Graph
    attr_reader :nodes

    PADDING = 10

    def initialize
      @nodes = []
      @width = 0
      @height = 0
    end

    def <<(node)
      labels = @nodes.map(&:label)
      @nodes << node unless labels.include?(node.label)
    end

    def find_node_by_label(label)
      (@nodes || []).select { |node| node.label == label }.first
    end

    def layered_nodes
      @layered_nodes ||= @nodes.sort_by(&:level).group_by(&:level).values
    end

    def layer_nodes
      nodes_with_level = @nodes.select { |node| node.level >= 1 }
      begin
        diff_total = 0
        nodes_with_level.each do |node|
          node.children.each do |child|
            if node.level >= child.level
              child.level += node.level + 1
              diff_total += node.level + 1
            end
          end
        end
      end while diff_total != 0
    end

    def layout_nodes
      layer_widths = []
      layer_offset = PADDING
      layered_nodes.each do |nodes|
        node_offset = PADDING
        nodes.each do |node|
          node.x = node_offset
          node.y = layer_offset
          node_offset += node.width + Node::MARGIN_RIGHT
        end
        layer_widths << node_offset + PADDING
        layer_offset += nodes.map(&:height).max + Node::MARGIN_BOTTOM
      end
      @width = layer_widths.max
      @height = layer_offset + PADDING
    end

    def layout_edges
      @nodes.each do |node|
        node.child_edges.each_with_index do |edge, index|
          edge.origin.x = node.x + (node.width.to_f * (index + 1) / (node.child_edges.count + 1))
          edge.origin.y = node.y + node.height
        end

        node.parent_edges.each_with_index do |edge, index|
          edge.target.x = node.x + (node.width.to_f * (index + 1) / (node.parent_edges.count + 1))
          edge.target.y = node.y
        end
      end
    end

    def to_svg
      svg = SVGen::SVG.new(width: @width, height: @height) do |svg|
        # nodes
        svg.g(fill: "none", stroke: "black") do |g|
          @nodes.each do |node|
            g.rect(x: node.x, y: node.y, width: node.width, height: node.height)
          end
        end

        # texts
        svg.g("font-size" => Node::FONT_SIZE, "font-family" => Node::FONT_FAMILY, "text-anchor" => "middle") do |g|
          @nodes.each do |node|
            g.text(node.label, x: node.x + node.width / 2, y: node.y + Node::WORD_HEIGHT + Node::PADDING_TOP / 2)
          end
        end

        # edges
        svg.g(stroke: "black", "stroke-width" => 2) do |g|
          @nodes.each do |node|
            node.child_edges.each do |edge|
              g.path(d: edge.line_d, fill: "none")
              g.path(d: edge.arrow_d, fill: "black") if edge.forward?
              g.path(d: edge.reverse_arrow_d, fill: "black") if edge.backward?
            end
          end
        end
      end
      svg.generate
    end
  end
end
