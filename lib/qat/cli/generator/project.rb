require_relative '../../cucumber/version'
require 'fileutils'

module QAT::CLI::Generator

  #New project generator
  # @since 0.1.0
  class Project
    include FileUtils

    def initialize stdin=STDIN, stdout=STDOUT, stderr=STDERR, kernel=Kernel
      @fileutils_output = stdout
    end

    #Create a new project. Will create a new folder with the project's name.
    #@param name [String] The new project's name
    def run! name, opts={}

      raise ArgumentError.new 'No project name given' unless name
      raise ArgumentError.new "The project '#{name}' already exists" if ::File.directory? name

      mkdir name, opts
      cp_r ::File.join(::File.dirname(__FILE__), '..', '..', 'project', '.'), name, opts
      cd name, opts do
        mkdir_p ::File.join('config', 'common'), opts
        mkdir_p 'lib', opts
        mkdir_p 'public', opts
      end

    end
  end
end