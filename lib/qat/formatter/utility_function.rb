
module QAT
  module Formatter
    # Helper for Formatters , most of the main methods are done to reduce code duplication
    module UtilityFuction



      def background(background)
        @background_hash = {
          keyword:     background.keyword,
          name:        background.name,
          description: background.description.nil? ? '' : background.description,
          line:        background.location.line,
          type:        'background'
        }
      end

      def create_feature_hash feature,uri
        @feature_hash = {
          id:          feature.name,
          uri:         uri,
          keyword:     feature.keyword,
          name:        feature.name,
          description: feature.description.nil? ? '' : feature.description,
          line:        feature.location.line
        }
      end

      def get_lines_from_scenario(scenario_source, test_case)
        if scenario_source.type == :Scenario
          test_case.location.lines.max
        else
          test_case.location.lines.min
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
            add_values_to_examples row[:cells]
          end
        end
      end

      def internal_hook?(test_step)
        test_step.location.file.include?('lib/qat/cucumber/')
      end

      def support_hook?(test_step)
        test_step.location.file.include?('features/support/hooks')
      end




    end
  end
end