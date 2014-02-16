require "redcarpet"
require "pathname"
require "optparse"

module Graphdown
  class CLI
    def self.start(args)
      method_name = args.shift
      new.send(method_name, *args)
    end

    def initialize
      @options = {}
      @option_parser = OptionParser.new
    end

    def parse(name, *args)
      @option_parser.on("-o", "--output FILENAME") { |filename| @options[:output] = filename }
      @option_parser.parse!(args)

      markdown_path = Pathname.new(name).expand_path
      output_filename = @options[:output] || File.basename(name, ".md") + ".html"
      html_path = markdown_path.dirname.join(output_filename)

      renderer = Class.new(Redcarpet::Render::HTML)
      renderer.send(:include, Graphdown::Renderable)
      markdown = Redcarpet::Markdown.new(renderer)

      html = markdown.render(markdown_path.read)
      html_path.open("wb") { |file| file.write(html) }
    end

    def method_missing(name, *args)
      case name.to_s
      when /\.md$/
        parse(name.to_s, *args)
      when "-h", "--help"
        args << "--help"
        parse(name.to_s, *args)
      when "-v", "--version"
        puts Graphdown::VERSION
      else
        super
      end
    end
  end
end
