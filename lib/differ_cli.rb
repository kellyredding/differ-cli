require 'quickl'
require 'differ'
require "differ_cli/version"


module DifferCLI

  #
  # differ command line tool
  #
  # SYNOPSIS
  #   #{command_name} [options] LEFT RIGHT
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #   This is a command line tool for using differ
  #
  class Differ < Quickl::Command(__FILE__, __LINE__)

    VERSION = DifferCli::VERSION

    # Install options
    options do |opt|

      @differ_cli_opts = {}

      opt.on_tail('--help', "Show this help message") do
        raise Quickl::Help
      end

      opt.on_tail('--version', 'Show version and exit') do
        raise Quickl::Exit, "#{Quickl.program_name} #{VERSION}"
      end

      opt.on('--method METHOD', 'the diff method: line, word, or char (default)') do |method|
        @differ_cli_opts[:method] = method
      end

      opt.on('--format FORMAT', 'the output format: ascii, color (default), html, or esc') do |method|
        @differ_cli_opts[:format] = method
      end

      opt.on('-a', '--ascii', 'format output in ascii') do
        @differ_cli_opts[:format] = 'ascii'
      end

      opt.on('-c', '--color', 'format output in color') do
        @differ_cli_opts[:format] = 'color'
      end

      opt.on('-h', '--html', 'format output in html') do
        @differ_cli_opts[:format] = 'html'
      end

      opt.on('-e', '--esc', 'format output as html-escaped w/ color') do
        @differ_cli_opts[:format] = 'bcat'
      end

    end

    # Run the command
    def execute(args)
      puts
      puts '----------------'
      puts Base.new(*(args+[@differ_cli_opts || {}])).diff
      puts '----------------'
    end

  end

  class Base

    METHODS = ['line', 'word', 'char']
    FORMATS = ['ascii', 'color', 'html', 'bcat']

    attr_accessor :left, :right, :diff_method, :boundary_string
    attr_accessor :diff

    def initialize(*params)
      opts, args = [
        params.last.kind_of?(::Hash) ? params.pop : {},
        params
      ]

      raise Quickl::Exit, "too few arguments: #{args.join(', ')}" if args.size < 2
      raise Quickl::Exit, "too many arguments: #{args.join(', ')}" if args.size > 2

      @left  = args.first
      @right = args.last
      self.diff_method = opts[:method] || 'char'
      self.format_as = opts[:format] || 'color'
      @diff = ::Differ.send("diff_by_#{@diff_method}", *[@left, @right])
    end

    def diff_method=(value)
      raise Quickl::Exit, "invalid method '#{value}'" unless METHODS.include?(value.to_s)
      @diff_method = value
    end

    def format_as=(value)
      raise Quickl::Exit, "invalid format '#{value}'" unless FORMATS.include?(value.to_s)
      @format_as = value
    end

    def diff
      case @format_as
      when 'esc'
        # format as color and escape for html output
        escape_html(@diff.format_as(:color))
      else
       @diff.format_as(@format_as.to_sym)
     end
    end

    private

    # Ripped from Rack v1.3.0 ======================================
    # => ripped b/c I don't want a dependency on Rack for just this
    ESCAPE_HTML = {
      "&" => "&amp;",
      "<" => "&lt;",
      ">" => "&gt;",
      "'" => "&#x27;",
      '"' => "&quot;",
      "/" => "&#x2F;"
    }
    ESCAPE_HTML_PATTERN = Regexp.union(*ESCAPE_HTML.keys)
    # Escape ampersands, brackets and quotes to their HTML/XML entities.
    def escape_html(string)
      string.to_s.gsub(ESCAPE_HTML_PATTERN){|c| ESCAPE_HTML[c] }
    end
    # end Rip from Rack v1.3.0 =====================================

  end

end
