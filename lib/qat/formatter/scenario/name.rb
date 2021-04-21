require 'cucumber/formatter/io'
require 'json'
require_relative '../helper'

module QAT
  module Formatter
    module Scenario
      class Name
        include Cucumber::Formatter::Io
        include QAT::Formatter::Helper

        def initialize(config)
          @config = config
          @io     = ensure_io(config.out_stream, config.error_stream)
          #  @to_file   = (@io != $stdout)
          @to_file        = @io
          @scenarios      = {}
          @repeated       = {}
          @ast_lookup     = ::Cucumber::Formatter::AstLookup.new(config)
          @feature_hashes = []
          config.on_event :test_case_started, &method(:on_test_case_started)
          config.on_event :test_run_finished, &method(:on_test_run_finished)
        end


        def on_test_case_started event
          @examples_values = []
          build(event.test_case, @ast_lookup)
          @current_feature = @feature_hash
          scenario_name
        end

        def scenario_name
          if @to_file
            if @scenarios.values.include?(@scenario[:name])
              file_colon_line = "#{@current_feature[:uri]}:#{@scenario[:line]}"
              unless @scenarios.keys.include?(file_colon_line)
                @repeated[@scenario[:name]] ||= []
                @repeated[@scenario[:name]] << "#{@current_feature[:uri]}:#{@scenario[:line]}"
              end
            end
            file_colon_line             = "#{@current_feature[:uri]}:#{@scenario[:line]}"
            @scenarios[file_colon_line] = @scenario[:name]
          else
            Kernel.puts "#{@scenario[:name]}: #{file_colon_line}"
          end
        end

        def on_test_run_finished(_event)
          if @to_file
            content = {
              scenarios: @scenarios,
              repeated:  @repeated
            }
            @io.write (JSON.pretty_generate(content))
            @io.flush
          end
        end




      end
    end
  end
end
