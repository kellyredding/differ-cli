require 'differ-cli/cli'
require 'differ-cli/differ'
require 'differ-cli/version'

class DifferCLI

  def initialize
    @cli = CLIRB.new do
      option :method, "diff method: line, word (default), or char", {
        :value => String
      }
      option :format, "output format: ascii (default), color, html, or esc", {
        :value => String
      }
      option :ascii, "format output in ascii"
      option :color, "format output in color"
      option :html,  "format output in html"
      option :esc,   "format output as escaped-html w/ color"
    end
  end

  def run(*args)
    begin
      @cli.parse!(*args)

      a = @cli.args; aa = a.map(&:inspect).join(', ')
      raise CLIRB::Error, "too few arguments (#{a.size}): #{aa}"  if a.size < 2
      raise CLIRB::Error, "too many arguments (#{a.size}): #{aa}" if a.size > 2

      @cli.opts['method'] ||= 'word'
      @cli.opts['format'] ||= 'ascii' if @cli.opts['ascii']
      @cli.opts['format'] ||= 'color' if @cli.opts['color']
      @cli.opts['format'] ||= 'html'  if @cli.opts['html']
      @cli.opts['format'] ||= 'ascii'

      begin
        puts Differ.new(*@cli.data).diff
      rescue DifferCLI::DifferError => err
        raise CLIRB::Error, err.message
      end
    rescue CLIRB::HelpExit
      puts help_msg
      exit(0)
    rescue CLIRB::VersionExit
      puts DifferCLI::VERSION
      exit(0)
    rescue CLIRB::Error => err
      puts "#{err.message}\n\n"
      puts help_msg
      exit(1)
    rescue Exception => err
      puts "#{err.message}\n\n"
      exit(1)
    end
  end

  def help_msg
    "Usage: differ [opts] LEFT RIGHT\n"\
    "#{@cli}"
  end

end
