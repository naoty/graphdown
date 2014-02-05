module Graphdown
  class Node
    attr_accessor :x, :y
    attr_reader :label, :parent_edges, :child_edges

    FONT_SIZE = 18
    FONT_FAMILY = "monospace"

    WORD_HEIGHT = 25
    PADDING_TOP = 5
    PADDING_LEFT = 10
    MARGIN_RIGHT = 20
    MARGIN_BOTTOM = 50

    def initialize(label)
      @x = 0
      @y = 0
      @label = label
      @parent_edges = []
      @child_edges = []
    end

    def width
      text_width = 13 + (@label.length - 1) * 9
      text_width + PADDING_LEFT * 2
    end

    def height
      WORD_HEIGHT + PADDING_TOP  * 2
    end

    def connect(child, direction = :forward)
      # Prevent closed path
      direction = ancestors.include?(child) ? :backward : direction
      edge = Edge.new(self, child, direction)
      if direction == :backward
        self.parent_edges << edge
        child.child_edges << edge
      else
        self.child_edges << edge
        child.parent_edges << edge
      end
    end

    def parents
      parent_edges.map(&:parent)
    end

    def ancestors
      ancestors = []
      ascend = ->(node) do
        ancestors << node
        node.parents.each { |parent| ascend.call(parent) }
      end
      parents.each { |parent| ascend.call(parent) }
      ancestors
    end

    def children
      child_edges.map(&:child)
    end

    def descendants
      descendants = []
      descend = ->(node) do
        descendants << node
        node.children.each { |child| descend.call(child) }
      end
      children.each { |child| descend.call(child) }
      descendants
    end
  end
end
