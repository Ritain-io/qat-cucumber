 require_relative 'utility_function'

module QAT
  module Formatter
    # Helper for Formatters , most of the main methods are done to reduce code duplication
    module Builder
      include QAT::Formatter::UtilityFuction


      def build (test_case, ast_lookup)
        @background_hash = nil
        uri              = test_case.location.file
        feature          = ast_lookup.gherkin_document(uri).feature
        feature(feature, uri)
        background = feature.children.first.background
        background(background) if background
        scenario(ast_lookup.scenario_source(test_case), test_case)
      end

      def feature (feature, uri)
        feature_tags = feature.tags
        create_feature_hash feature, uri
        return if feature_tags.empty?
        tags_array = []
        feature_tags.each { |tag| tags_array << tag.name }
        @feature_hash[:tags] = tags_array
      end

      def scenario(scenario_source, test_case)
        scenario    = scenario_source.type == :Scenario ? scenario_source.scenario : scenario_source.scenario_outline
        @scenario   = {
          id:          "#{@feature_hash[:id]};#{create_id_from_scenario_source(scenario_source)}",
          keyword:     scenario.keyword,
          name:        test_case.name,
          description: scenario.description || '',
          line:        get_lines_from_scenario(scenario_source, test_case),
          type:        'scenario'
        }

        get_scenario_tags test_case.tags
      end

      def get_scenario_tags tags
        if tags.empty?
          @scenario[:tags] = []
        else
          tags_array = []

         tags.each { |tag|
            name = tag.name
            if @test_id_tags
              tags_array << name unless name.match(/@test#(\d+)/)
            else
              tags_array << name
            end
          }

          @scenario[:tags] = tags_array
        end
      end


      def create_id_from_scenario_source(scenario_source)
        if scenario_source.type == :Scenario
          @examples_values = nil
          scenario_source.scenario.name
        else
          @examples_values      = []
          scenario_outline_name = scenario_source.scenario_outline.name
          examples_name         = scenario_source.examples.name
          get_example_values scenario_source
          @row_number = calculate_row_number(scenario_source)
          "#{scenario_outline_name};#{examples_name};#{@row_number}"
        end
      end


      def add_values_to_examples(cells)
        @examples_values =  cells.map do |data|
          data[:value].to_s
        end
      end

    end
  end
end