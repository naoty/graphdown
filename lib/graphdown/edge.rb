require "matrix"

module Graphdown
  class Edge
    attr_accessor :origin, :target

    DIRECTION = [:forward, :backward, :two_way].freeze
    ARROW_SIDE_LENGTH = 10

    def initialize(origin_node, target_node, direction = :forward)
      @origin_node = origin_node
      @target_node = target_node
      @direction = DIRECTION.include?(direction) ? direction : :forward
      @origin = Point.new
      @target = Point.new
    end

    def parent
      case @direction
      when :forward  then @origin_node
      when :backward then @target_node
      when :two_way  then @origin_node
      end
    end

    def child
      case @direction
      when :forward  then @target_node
      when :backward then @origin_node
      when :two_way  then @target_node
      end
    end

    def line_d
      "M #{@origin.x} #{@origin.y} L #{@target.x} #{@target.y}"
    end

    def arrow_d
      ratio = ARROW_SIDE_LENGTH / length
      p1 = vector.scale(ratio).rotate(Math::PI / 6 * 5).point
      p2 = vector.scale(ratio).rotate(-Math::PI / 6 * 5).point

      p1.x += @target.x
      p1.y += @target.y
      p2.x += @target.x
      p2.y += @target.y

      "M #{@target.x} #{@target.y} L #{p1.x} #{p1.y} L #{p2.x} #{p2.y} Z"
    end

    private

    def length
      dx = @target.x - @origin.x
      dy = @target.y - @origin.y
      Math.sqrt(dx ** 2 + dy ** 2)
    end

    def vector
      Graphdown::Edge::Vector.new(@target.x - @origin.x, @target.y - @origin.y)
    end

    class Vector
      def initialize(x, y)
        @v = Matrix[[x, y]]
        @matrices = []
      end

      def point
        @matrices.each { |matrix| @v *= matrix }
        x, y = @v.row(0).to_a
        Point.new(x, y)
      end

      def scale(ratio)
        unit_vector = @v.row(0).normalize
        nx, ny = unit_vector.map(&:to_f).to_a
        scaling_matrix = Matrix[[1 + (ratio - 1) * nx ** 2, (ratio - 1) * nx * ny],
                                [(ratio - 1) * nx * ny, 1 + (ratio - 1) * ny ** 2]]
        @matrices << scaling_matrix
        self
      end

      def rotate(radian)
        rotation_matrix = Matrix[[Math.cos(radian), Math.sin(radian)],
                                 [-Math.sin(radian), Math.cos(radian)]]
        @matrices << rotation_matrix
        self
      end
    end
  end
end
