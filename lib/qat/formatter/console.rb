require 'fileutils'
require 'cucumber/formatter/console'
require 'cucumber/formatter/io'
require 'cucumber/gherkin/formatter/escaping'
require 'qat/logger'
require_relative 'loggable'

module QAT
  module Formatter
    # Formatter to print Feature, Scenario and Step information on the fly. Will use STDOUT by default or a specified
    # logger configuration channel.
    #@see QAT::Loggger
    #@since 0.1.0
    class Console
      include ::FileUtils
      include ::Cucumber::Formatter::Io
      include ::Cucumber::Gherkin::Formatter::Escaping
      include QAT::Formatter::Loggable
      include QAT::Logger

      #@api private
      def initialize(_, path_or_io, options)
        @options = options

        check_outputter path_or_io unless options[:dry_run]
      end

      #@api private
      def before_test_case test_case
        return if @options[:dry_run]

        unless @current_feature
          @current_feature = test_case.source[0]
          log.info { "Running #{@current_feature.keyword}: \"#{@current_feature.name}\"" }
          mdc_before_feature! @current_feature.name
        end

        @current_scenario = test_case.source[1]
      end

      #@api private
      def after_feature *_
        return if @options[:dry_run]

        log.info { "Finished #{@current_feature.keyword}: \"#{@current_feature.name}\"" }
        @current_feature = nil
        mdc_after_feature!
      end

      #@api private
      def after_test_case step, result
        return if @options[:dry_run]

        log.error { result.exception } if result.failed?

        log.info { "Finished #{@current_scenario.keyword}: \"#{format_scenario_name step}\" - #{result.to_sym}\n" } if @current_scenario
      end

      #@api private
      def before_test_step step
        return if @options[:dry_run]

        begin_test_step step do |type|
          case type
            when :after_step
              log.info "Step Done!" if @step_running
            when :before_scenario
              before_test_case step unless @current_feature
              log.info { "Running #{@current_scenario.keyword}: \"#{format_scenario_name step}\"" }
            when :before_step
              log.info "Step Done!\n" if @step_running
              step_name = "#{step.source.last.keyword}#{step.to_s}"
              log.info { "Step \"#{step_name}\"" }
              mdc_add_step! step_name
          end
        end
      end

      #@api private
      def puts obj
        return if @options[:dry_run]

        log.debug { obj }
      end

      private
      def format_scenario_name step
        return '' unless @current_scenario
        outline_number, outline_example = nil, nil
        scenario_name                   = if @current_scenario.is_a? ::Cucumber::Core::Ast::ScenarioOutline
                                            outline_example = step.source[3].values
                                            outline_number  = calculate_outline_id(step)
                                            "#{@current_scenario.name} ##{outline_number}"
                                          else
                                            @current_scenario.name
                                          end
        mdc_before_scenario! @current_scenario.name, tags_from_test_step(step), outline_number, outline_example
        return scenario_name
      end
    end
  end
end