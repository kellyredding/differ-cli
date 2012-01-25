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

      opt.on('--method METHOD', 'Specify a diff method (line, word, char)') do |method|
        @differ_cli_opts[:method] = method
      end
    end

    # Run the command
    def execute(args)
      puts "Hello #{@differ_cli_opts[:method].inspect} #{args.join(' and ')} from #{Quickl.program_name}"
    end

  end

  class Base

    attr_accessor :left, :right, :diff_method, :boundary_string

    def initialize(*args)

    end

  end

end
