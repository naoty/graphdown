module Graphdown
  class Node
    attr_reader :label

    FONT_SIZE = 18
    FONT_FAMILY = "monospace"

    WORD_HEIGHT = 25
    PADDING_TOP = 5
    PADDING_LEFT = 10

    def initialize(label)
      @label = label
    end

    def width
      text_width = 13 + (@label.length - 1) * 9
      text_width + PADDING_LEFT * 2
    end

    def height
      WORD_HEIGHT + PADDING_TOP  * 2
    end
  end
end
