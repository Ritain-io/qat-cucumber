require_relative '../cli'
require_relative '../cucumber/version'
require_relative 'generator'
require 'optparse'
require 'fileutils'
require 'time'

#Main class for the CLI.
#@since 0.1.0
class QAT::CLI::Main
  include QAT::CLI::Generator

  #Initialization from command line
  def initialize(argv, stdin = STDIN, stdout = STDOUT, stderr = STDERR, kernel = Kernel)
    @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
    @options                                 = {}
    @sub_options                             = {}
    @exit_code                               = 0
  end

  #Main entry point for execution
  def execute!
    parse_argv!

    handle_options if @options.any?

  rescue ArgumentError, OptionParser::MissingArgument => exception
    @stderr.Kernel.puts "Error: #{exception.message}"
    @exit_code = 1
  ensure
    @kernel.exit(exit_code)
  end

  private

  attr_accessor :exit_code

  def parse_argv!
    @argv = ['-h'] if @argv.empty?

    opts = OptionParser.new do |parser|
      parser.banner = 'Usage: qat [OPTIONS]'
      # parser.separator ''
      parser.separator 'Options'

      project_options(parser)
    end

    opts.parse!(@argv)
  end

  def handle_options
    if @options.has_key? :project
      create_project(@options[:project])
    elsif @options.has_key? :modules
      add_modules(@options[:modules])
    end
  end

  def project_options(parser)
    parser.on('-n', '--new [NAME]', String, 'Create new project') do |project|
      @options[:project] = project
    end

    parser.on('-a', '--add [MODULES]', Array, 'Integrate modules in project') do |modules|
      @options[:modules] = parse_modules(modules)
    end

    parser.on('-l', '--list', 'Show available modules') do
      list_available_modules
      @exit_code = 0
    end

    parser.on('-r', '--verbose', 'Show detailed information') do
      @sub_options[:verbose] = true
    end

    parser.on('-v', '--version', 'Show QAT-Cucumber version') do
      @stdout.Kernel.puts QAT::Cucumber::VERSION
      @exit_code = 0
    end

    parser.on('-h', '--help', 'Show this helper') do
      @stdout.Kernel.puts parser.help
      @exit_code = 0
    end
  end

  def parse_modules(modules)
    modules          = modules.to_a
    existing_modules = @options[:modules]
    existing_modules ? existing_modules + modules : modules
  end

  def list_available_modules
    modules = QAT::CLI.list_extentions

    @stdout.Kernel.puts 'List of available modules:'
    names = modules.map { |module_name| "\t#{module_name}" }
    @stdout.Kernel.puts names.join("\n")
  end
end