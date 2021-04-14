require 'cucumber/formatter/io'
require 'json'

module QAT
  module Formatter
    module Scenario
      class Name
        include Cucumber::Formatter::Io

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

        def build (test_case, ast_lookup)
          @background_hash = nil
          uri              = test_case.location.file
          feature          = ast_lookup.gherkin_document(uri).feature
          feature(feature, uri)
          background(feature.children.first.background) unless feature.children.first.background.nil?
          scenario(ast_lookup.scenario_source(test_case), test_case)
        end


        def on_test_case_started event
          @examples_values = []
          test_case        = event.test_case
          build(test_case, @ast_lookup)
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


        private

        def background(background)
          @background_hash = {
            keyword:     background.keyword,
            name:        background.name,
            description: background.description.nil? ? '' : background.description,
            line:        background.location.line,
            type:        'background'
          }
        end


        def feature (feature, uri)
          @feature_hash = {
            id:          feature.name,
            uri:         uri,
            keyword:     feature.keyword,
            name:        feature.name,
            description: feature.description.nil? ? '' : feature.description,
            line:        feature.location.line
          }
          return if feature.tags.empty?
          tags_array = []
          feature.tags.each { |tag| tags_array << tag.name }
          @feature_hash[:tags] = tags_array
        end

        def scenario(scenario_source, test_case)
          scenario  = scenario_source.type == :Scenario ? scenario_source.scenario : scenario_source.scenario_outline
          @scenario = {
            id:          "#{@feature_hash[:id]};#{create_id_from_scenario_source(scenario_source)}",
            keyword:     scenario.keyword,
            name:        test_case.name,
            description: scenario.description.nil? ? '' : scenario.description,
            line:        get_lines_from_scenario(scenario_source, test_case),
            type:        'scenario'
          }
          if test_case.tags.empty?
            @scenario[:tags] = []
          else
            tags_array = []
            test_case.tags.each { |tag| tags_array << tag.name }
            @scenario[:tags] = tags_array
          end
        end

        def get_lines_from_scenario(scenario_source, test_case)
          if scenario_source.type == :Scenario
            test_case.location.lines.max
          else
            test_case.location.lines.min
          end
        end

        def create_id_from_scenario_source(scenario_source)
          if scenario_source.type == :Scenario
            scenario_source.scenario.name
          else
            scenario_outline_name = scenario_source.scenario_outline.name
            examples_name         = scenario_source.examples.name
            get_example_values scenario_source
            @row_number = calculate_row_number(scenario_source)
            "#{scenario_outline_name};#{examples_name};#{@row_number}"
          end
        end

        def calculate_row_number(scenario_source)
          scenario_source.examples.table_body.each_with_index do |row, index|
            return index + 1 if row == scenario_source.row
          end
        end

        def get_example_values(scenario_source)
          scenario_source.examples.table_body.each do |row|

            if row == scenario_source.row
              row[:cells].each do |data|
                @examples_values << data[:value].to_s
              end
            end
            @examples_values
          end
        end

      end
    end
  end
end
