module QAT
  module CLI
    module Plugins
      #Plugin for CLI functions
      #@since 0.1.0
      module Core

        #Function for adding the Core module to a project. Just used for testing, does nothing.
        #@param stdout [IO] Stdout stream
        #@param opts [Hash] Options hash
        #@since 0.1.0
        def self.add_module stdout, opts
          stdout.puts 'Nothing to add in Core module' if opts[:verbose]
        end

      end
    end
  end
end