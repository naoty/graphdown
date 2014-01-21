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
        %(<img href="sample.png"/>)
      else
        block_code_without_graphdown(code, language)
      end
    end
    alias block_code block_code_with_graphdown
  end
end
