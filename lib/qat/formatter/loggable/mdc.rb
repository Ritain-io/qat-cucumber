require 'qat/logger'
require_relative 'scenario_info'

module QAT
  module Formatter
    module Loggable
      #Helper module to manage loggable mdc information
      #@since 2.0.2
      module Mdc
        include ScenarioInfo

        #Set the MDC key 'feature' with the given value.
        #@param feature_name [String] Name of the current feature
        #@since 0.1.0
        def mdc_before_feature!(feature_name)
          Log4r::MDC.put 'feature', feature_name
        end

        #Remove the MDC key 'feature'.
        #@since 0.1.0
        def mdc_after_feature!
          Log4r::MDC.remove 'feature'
        end

        #Set the MDC key 'scenario' with the given value.
        #Optionally scenario outline data can also be provided
        #@param scenario_name [String] Name of the current feature
        #@param tags [Array<String>] List of tags
        #@param outline_number [Integer] Number of the current scenario outline
        #@param outline_example [Array<String>] Values of the current outline's example row
        #@since 0.1.0
        def mdc_before_scenario!(scenario_name, tags, outline_number = nil, outline_example = nil)
          mdc_reset_scenario!
          Log4r::MDC.put 'scenario', scenario_name

          test_id = test_id(tags, outline_number)
          Log4r::MDC.put 'test_id', test_id
          loggable_tags = tags.reject { |tag| tag.match(/^\@test\#/) }
          Log4r::MDC.put 'tags', loggable_tags

          log.warn  outline_example
          Log4r::MDC.put 'outline_number', outline_number if outline_number
          Log4r::MDC.put 'outline_example', outline_example if outline_example
        end

        #Remove the MDC key 'scenario'. Other options set in #mdc_before_scenario! will also be unset.
        #@since 0.1.0
        def mdc_reset_scenario!
          mdc_remove_step!
          Log4r::MDC.remove 'scenario'
          Log4r::MDC.remove 'tags'
          Log4r::MDC.remove 'outline_number'
          Log4r::MDC.remove 'outline_example'
        end

        #Set the MDC key 'step' with the given value.
        #@param step_name [String] Name of the current step
        #@since 0.1.0
        def mdc_add_step!(step_name)
          Log4r::MDC.put 'step', step_name
        end

        #Remove the MDC key 'step'.
        #@since 0.1.0
        def mdc_remove_step!
          Log4r::MDC.remove 'step'
        end

        def mdc_add_status_failed!
          Log4r::MDC.put 'status', 'failed'
        end
      end
    end
  end
end