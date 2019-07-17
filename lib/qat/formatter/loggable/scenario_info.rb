require 'qat/logger'

module QAT
  module Formatter
    module Loggable
      #Helper module to manage loggable scenario information
      #@since 2.0.2
      module ScenarioInfo
        protected

        def tags_from_test_step(step)
          step.source.inject([]) do |sum, current_source|
            sum << current_source.tags if current_source.respond_to? :tags
            sum
          end.flatten.map(&:name)
        end

        def test_id(tags, outline_id)
          tag = tags.select { |tag| tag.match /^\@test\#\d+$/ }.first
          if tag
            id = tag.gsub '@test#', 'test_'
            id << ".#{outline_id}" if outline_id
            id
          else
            nil
          end
        end

        def calculate_outline_id(step)
          source            = step.source
          tables            = source[1].instance_exec { @examples_tables }
          table_lines       = tables.each.map { |line| line.example_rows.size }
          table_num         = tables.index source[2]
          previous_outlines = table_lines[0...table_num].inject(0) { |sum, lines| sum += lines; sum }
          "#{previous_outlines + source[3].number}".to_i
        end
      end
    end
  end
end