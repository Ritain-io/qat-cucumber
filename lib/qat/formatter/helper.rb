require_relative 'builder'
require_relative 'utility_function'

module QAT
  module Formatter
    # Helper for Formatters , most of the main methods are done to reduce code duplication
    module Helper
      include QAT::Formatter::Builder
      include QAT::Formatter::UtilityFuction



      def on_test_case_started event
        return if @config.dry_run?
        @row_number = nil
        test_case   = event.test_case
        build(test_case, @ast_lookup)
        assign_print_feature unless @current_feature
        @current_scenario = @scenario
        scenario_name     = @current_scenario[:name]
        print_scenario_start @current_scenario[:keyword], scenario_name
        mdc_before_scenario! scenario_name, @current_scenario[:tags], @row_number, @examples_values
      end


      def on_test_case_finished event
        return if @config.dry_run?
        _test_case, result = *event.attributes
        @current_feature   = nil
        if result.failed?
          mdc_add_step! @mdc_text
          mdc_add_status_failed!
          log.error { result.exception }
        else
          print_scenario_results @current_scenario[:keyword], @current_scenario[:name], result
        end
      end

      def on_test_step_started(event)
        return if @config.dry_run?
        test_step = event.test_step
        return if internal_hook?(test_step)
        return if support_hook?(test_step)
        step_source = @ast_lookup.step_source(test_step).step
        print_assign_step test_step, step_source
      end


      def on_test_step_finished(event)
        return if @config.dry_run?
        test_step, result = *event.attributes
        return if internal_hook?(test_step)
        return if support_hook?(test_step)
        log.info "Step Done!"
      end

      def on_test_run_finished _event
        return if @config.dry_run?
        print_scenario_results @feature_hash[:keyword], @feature_hash[:name]
        mdc_after_feature!
      end

      def assign_print_feature
        @current_feature = @feature_hash
        feature_name     = @current_feature[:name]
        print_scenario_start @current_feature[:keyword], feature_name
        mdc_before_feature! feature_name
      end


      def print_assign_step test_step, step_source
        test_step_text = test_step.text
        log.info { "Step \"#{test_step_text}\"" }
        @mdc_text = "#{step_source.keyword}#{test_step_text}"
        mdc_add_step! @mdc_text
      end

      def print_scenario_results keyword, name, result = nil
        if result
          log.info { "Finished #{keyword}: \"#{name}\" - #{result}\n" }
        else
          log.info { "Finished #{keyword}: \"#{name}\"" }
        end
      end

      def print_scenario_start keyword, name
        log.info { "Running #{keyword}: \"#{name}\"" }
      end
    end
  end
end