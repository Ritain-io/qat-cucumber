require 'little-plugger'

module QAT
  #Module for CLI functions
  #@since 0.1.0
  module CLI
    #Module as namespace for plugin definition
    #@since 0.1.0
    module Plugins
      #Placeholder
    end
    # @!parse extend LittlePlugger
    send :extend, LittlePlugger( :path => 'qat/cli/plugins', :module => ::QAT::CLI::Plugins )

    #Lists all registered extentions/plugins
    #@since 0.1.0
    def self.list_extentions
      plugins.keys.map(&:to_s).sort
    end

    #Call add_module in a given plugin.
    #@param mod [String,Symbol] name of the plugin to call
    #@param stdout [IO] stdout stream
    #@param opts [Hash] options hash
    #@raise ArgumentError When module does not exist
    #@since 0.1.0
    def self.add_module mod, stdout, opts
      raise ArgumentError.new "Module #{mod} is not a plugin!" unless has_module? mod

      loaded_mod = plugins[mod.to_sym]

      if loaded_mod.respond_to? :add_module
        meth = loaded_mod.method :add_module
        unless meth.arity == 2 || meth.arity < 0
          raise ArgumentError.new "Invalid implementation of add_module in #{mod}: should have 2 parameters: stdout, opts"
        end
        meth.call stdout, opts
      else
        stdout.puts "Nothing to add in #{mod}"
      end
    end


    #Check if a plugin exists
    #@param mod [String,Symbol] name of the plugin to call
    #@return [true,false] true if the plugin exists
    #@since 0.1.0
    def self.has_module? mod
      return plugins.has_key? mod.to_sym
    end
  end
end