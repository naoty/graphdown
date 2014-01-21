require "pathname"
require "pry"

module Graphdown
  module Renderable
    if defined?(block_code)
      alias block_code_without_graphdown block_code
    else
      def block_code_without_graphdown(code, language)
        %(<p><code>#{code}</code></p>)
      end
    end

    def block_code_with_graphdown(code, language)
      if language == "dot"
        if code =~ /digraph\s+(\w+)\s+{/
          dot_path = Pathname.pwd.join("#{$1}.dot")
          dot_path.open("wb") { |f| f.write(code) }
          graph_path = Pathname.pwd.join("#{$1}.png")
          generate_graph(dot_path.to_s, graph_path.to_s)
          dot_path.delete
          %(<img src="#{graph_path.to_s}"/>)
        else
          %(<img src="#"/>)
        end
      else
        block_code_without_graphdown(code, language)
      end
    end
    alias block_code block_code_with_graphdown

    private

    def generate_graph(source, output)
      system %(dot -Tpng -o #{output} #{source})
    end
  end
end
