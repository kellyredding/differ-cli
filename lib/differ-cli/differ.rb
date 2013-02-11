require 'differ'

class DifferCLI

  DifferError = Class.new(RuntimeError)

  class Differ

    METHODS = ['line', 'word', 'char']
    FORMATS = ['ascii', 'color', 'html', 'bcat']

    attr_accessor :left, :right

    def initialize(left, right, opts)
      @left, @right = left, right
      self.diff_method = opts['method']
      self.format_as = opts['format']
      @diff = ::Differ.send("diff_by_#{@diff_method}", @left, @right)
    end

    def diff_method=(value)
      raise DifferError, "invalid method '#{value}'" unless METHODS.include?(value.to_s)
      @diff_method = value
    end

    def format_as=(value)
      raise DifferError, "invalid format '#{value}'" unless FORMATS.include?(value.to_s)
      @format_as = value
    end

    def diff
      case @format_as
      when 'esc'
        # format as color and escape for html output
        escape_html(@diff.format_as('color'))
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
