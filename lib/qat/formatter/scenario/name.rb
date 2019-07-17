require 'cucumber/formatter/io'
require 'json'

module QAT
  module Formatter
    module Scenario
      class Name
        include Cucumber::Formatter::Io

        def initialize(runtime, path_or_io, options)
          @runtime   = runtime
          @io        = ensure_io(path_or_io)
          @to_file   = (@io != $stdout)
          @options   = options
          @scenarios = {}
          @repeated  = {}
        end

        def scenario_name(keyword, name, file_colon_line, source_indent)
          if @to_file
            if @scenarios.values.include?(name)
              @repeated[name] ||= []
              @repeated[name] << file_colon_line
            end
            @scenarios[file_colon_line] = name
          else
            puts "#{name}: #{file_colon_line}"
          end
        end

        def after_features(features)
          if @to_file
            content = {
              scenarios: @scenarios,
              repeated:  @repeated
            }
            @io.puts(content.to_json({
                                       indent:    ' ',
                                       space:     ' ',
                                       object_nl: "\n"
                                     }))
          end
        end
      end
    end
  end
end
