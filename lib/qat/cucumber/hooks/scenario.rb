# -*- encoding : utf-8 -*-
require 'cucumber'
require 'qat/logger'


module QAT
  module Cucumber
    #Methods to execute with Cucumber Hooks and at_exit.
    #@since 0.1.0
    module Hooks
      module Scenario
        include QAT::Logger

        def scenario_tags(scenario)
          scenario.tags.map { |tag| tag.name }.compact
        end

        def define_test_id(scenario)
          test_id = "#{test_id(scenario)}"

          QAT[:current_test_id]     = test_id
          QAT[:current_test_run_id] = "#{test_id}_#{QAT[:test_start_timestamp].to_i}"
          log.info "Scenario has test id: #{QAT[:current_test_id]} and test run id: #{QAT[:current_test_run_id]}"
        end

        private
        def test_id(scenario)
          # outline_id = get_outline_id(scenario)

          tags    = scenario_tags(scenario)
          tag     = tags.select { |tag| tag.match /^\@test\#/ }.first
          test_id = if tag
                      tag.gsub '@test#', 'test_'
                    else
                      log.warn "Scenario does not have a test id! Using a dummy one..."
                      'test_0'
                    end

          #"#{test_id}#{outline_id}"
          "#{test_id}"
        end

        # def get_outline_id(scenario)
        #   if scenario.is_a? ::Cucumber::RunningTestCase::ScenarioOutlineExample
        #     test_case        = scenario.instance_exec { @test_case }
        #     test_case_source = test_case.source
        #
        #     tables            = get_example_tables(test_case_source)
        #     table_lines       = get_examples_size(tables)
        #     table_num         = current_outline_index(tables, test_case_source)
        #     previous_outlines = count_previous_outlines(table_lines, table_num)
        #     "_#{previous_outlines + test_case_source[3].number}"
        #   else
        #     nil
        #   end
        # end
        #
        # def get_example_tables(test_case_source)
        #   test_case_source[1].instance_exec { @examples_tables }
        # end
        #
        # def get_examples_size(tables)
        #   tables.each.map { |table| table.example_rows.size }
        # end
        #
        # def current_outline_index(tables, test_case_source)
        #   tables.index test_case_source[2]
        # end
        #
        # def count_previous_outlines(table_lines, table_num)
        #   table_lines[0...table_num].inject(0) { |sum, lines| sum += lines; sum }
        # end

        extend self
      end
    end
  end
end