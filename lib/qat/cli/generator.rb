require_relative '../cucumber/version'

module QAT::CLI
  #Module for the various generators used in the CLI utility
  # @since 0.1.0
  module Generator
    # Creates a new QAT project with a given name
    # @param name [String] project name
    def create_project(name)
      QAT::CLI::Generator::Project.new(@stdin, @stdout, @stderr, @kernel).run! name, @sub_options

      if @options.has_key? :modules
        FileUtils.cd name, @sub_options do
          add_modules(@options[:modules])
        end
      end
    end

    # Adds QAT modules to the current project
    # @param modules [Array] list of modules' names to add
    def add_modules(modules)
      missing_modules = modules.reject { |mod| QAT::CLI.has_module? mod }

      if missing_modules.any?
        raise ArgumentError.new "Module#{missing_modules.size > 1 ? 's' : ''} #{missing_modules.join ','} missing!"
      end

      modules.each do |module_name|
        add_module(module_name)
      end
    end

    # Adds a QAT module to the current project
    # @param name [String] name of module to add
    def add_module(name)
      @stdout.puts "Adding module #{name}" if @sub_options[:verbose]
      begin
        QAT::CLI.add_module name, @stdout, @sub_options
        @stdout.puts "Module #{name} added to #{Dir.getwd.split(::File::SEPARATOR).last}"
      rescue => exception
        @stderr.puts "Error adding module #{name}: #{exception.message}"
        @exit_code = 1
      end
    end
  end
end

require_relative 'generator/project'