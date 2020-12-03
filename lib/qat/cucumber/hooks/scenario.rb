# -*- encoding : utf-8 -*-
require 'cucumber'
require 'qat/logger'
require 'cucumber/core/gherkin/writer'
require 'cucumber/formatter/ast_lookup'
require_relative '../core_ext/running_test_case'
require 'cucumber/formatter/json'

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

       #   "#{test_id}#{outline_id}"
           "#{test_id}"
        end


        ####  Cucumber::RunningTestCase::ScenarioOutlineExample deprecated
        def get_outline_id(scenario)




          scenarios = get_children(document[:feature])
          outline   = get_scenarios_outline scenarios
          if outline.empty?
            nil
          else

          end
        end

        def get_children(test_case_source)
          test_case_source.children! { @examples_tables }
        end


        def get_scenarios_outline(scenarios)
          scenarios_array = []
          scenarios.each do |item|
            scenarios_array << item.scenario.examples rescue nil
          end
          scenarios_array
        end

        def get_scenario_id(scenarios)
          scenarios_array = []
          scenarios.each do |item|
            scenarios_array << item.scenario.examples rescue nil
          end
          scenarios_array
        end


        extend self
      end
    end
  end
end