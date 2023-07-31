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

      if opts.present?
        mkdir name, verbose: true
        cp_r ::File.join(::File.dirname(__FILE__), '..', '..', 'project', '.'), name
        cd name do
          mkdir_p ::File.join('config', 'common'), verbose: true
          mkdir_p 'lib', verbose: true
          mkdir_p 'public', verbose: true
        end
      else
        mkdir name
        cp_r ::File.join(::File.dirname(__FILE__), '..', '..', 'project', '.'), name
        cd name do
          mkdir_p ::File.join('config', 'common')
          mkdir_p 'lib'
          mkdir_p 'public'
        end
      end


    end
  end
end