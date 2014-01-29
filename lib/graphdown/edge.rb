module Graphdown
  class Edge
    DIRECTION = [:forward, :backward, :two_way].freeze

    def initialize(origin, target, direction = :forward)
      @origin = origin
      @target = target
      @direction = DIRECTION.include?(direction) ? direction : :forward
    end

    def parent
      case @direction
      when :forward  then @origin
      when :backward then @target
      when :two_way  then @origin
      end
    end

    def child
      case @direction
      when :forward  then @target
      when :backward then @origin
      when :two_way  then @target
      end
    end
  end
end
