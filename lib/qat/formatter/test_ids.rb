require 'cucumber/formatter/io'
require 'json'

module QAT
  module Formatter
    class TestIds
      include Cucumber::Formatter::Io

      def initialize(config)
        @config             = config
        @io                 = ensure_io(config.out_stream, config.error_stream)
        @tags               = []
        @scenario_tags      = []
        @no_test_id         = {}
        @max_test_id        = 0
        @duplicate_test_ids = {}
        @test_id_mapping    = {}
        @ast_lookup         = ::Cucumber::Formatter::AstLookup.new(config)
        @feature_hashes     = []
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

      #@api private
      def on_test_case_started event
        @examples_values = []
        test_case        = event.test_case
        build(test_case, @ast_lookup)
        @current_feature = @feature_hash
        scenario_name
      end


      def on_test_run_finished(_event)
        publish_result
        @io.flush
      end


      def scenario_name
        if @scenario[:tags].any? { |tag| tag.match(/@test#(\d+)/) }
          id           = @scenario[:tags].map { |tag| tag.match(/@test#(\d+)/) }.compact.first.captures.first.to_i
          @max_test_id = id if id > @max_test_id

          test_id_info = { name: @scenario[:name],
                           path: "#{@current_feature[:uri]}:#{@scenario[:line]}" }

          if @test_id_mapping[id]
            if @duplicate_test_ids[id]
              @duplicate_test_ids[id].find do |dup|
                @exist = true if dup[:path]== test_id_info[:path]
              end
              @duplicate_test_ids[id] << test_id_info unless @exist
            else
              @duplicate_test_ids[id] = [@test_id_mapping[id], test_id_info] unless @test_id_mapping[id][:path] == test_id_info[:path]
            end
          else
            @test_id_mapping[id] = test_id_info
          end

        else
          @no_test_id[@scenario[:name]] = "#{@current_feature[:uri]}:#{@scenario[:line]}" unless @scenario[:tags].include?('@dummy_test')
        end
        @scenario[:tags] = []
      end

      private

      def publish_result
        content = {
          max:       @max_test_id,
          untagged:  @no_test_id,
          mapping:   Hash[@test_id_mapping.sort],
          duplicate: Hash[@duplicate_test_ids.sort]
        }

        if @duplicate_test_ids.any?
          dups_info = @duplicate_test_ids.map do |id, dups|
            text = dups.map { |dup| "Scenario: #{dup[:name]} - #{dup[:path]}" }.join("\n")
            "TEST ID #{id}:\n#{text}\n"
          end

          duplicates_info = <<-TXT.gsub(/^\s*/, '')
          ------------------------------------
          Duplicate test ids found!
          ------------------------------------
          #{dups_info.join("\n")}
          TXT
          Kernel.puts duplicates_info
        end

        @io.write (JSON.pretty_generate(content))
      end



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
          line:        get_lines_from_scenario(scenario_source,test_case),
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

      def get_lines_from_scenario(scenario_source,test_case)
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