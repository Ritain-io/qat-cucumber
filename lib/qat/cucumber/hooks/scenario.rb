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

        def test_id(scenario_source)
         # outline_id = get_outline_id(scenario)



          tags    = scenario_tags(scenario_source)
          tag     = tags.select { |tag| tag.match /^\@test\#/ }.first
          test_id = if tag
                      tag.gsub '@test#', 'test_'
                    else
                      log.warn "Scenario does not have a test id! Using a dummy one..."
                      'test_0'
                    end

         # "#{test_id}#{outline_id}"
           "#{test_id}"
        end


        extend self
      end
    end
  end
end