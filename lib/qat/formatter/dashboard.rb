require 'fileutils'
require 'cucumber/formatter/console'
require 'cucumber/formatter/io'
require 'cucumber/gherkin/formatter/escaping'
require 'qat/logger'
require_relative 'loggable'
require 'cucumber/core/gherkin/writer'
module QAT
  module Formatter
    # Formatter to send error information to a Dashboard server. Output should be configured in the logger file.
    #@see QAT::Loggger
    #@since 0.1.0
    class Dashboard
      include ::FileUtils
      include ::Cucumber::Formatter::Io
      include ::Cucumber::Gherkin::Formatter::Escaping
      include ::Cucumber::Core::Gherkin::Writer
      include QAT::Formatter::Loggable
      include QAT::Logger

      #@api private
      def initialize(config,options)
        @config            = config
        @io                = ensure_io(config.out_stream, config.error_stream)
      end


      #@api private
      def before_test_case test_case
        return if @config.dry_run?

        unless @current_feature
          @current_feature = test_case.source[0]
          mdc_before_feature! @current_feature.name
        end

        @current_scenario = test_case.source[1]
      end

      #@api private
      def after_feature *_
        return if @config.dry_run?

        @current_feature = nil
        mdc_after_feature!
      end

      #@api private
      def after_test_case step, passed
        return if @config.dry_run?

        if passed.respond_to? :exception
          mdc_add_step! @step_name
          mdc_add_status_failed!
          log.error passed.exception
        end
      end

      #@api private
      def before_test_step step
        return if @config.dry_run?

        begin_test_step step do |type|
          if type == :before_step
            @step_name = "#{step.source.last.keyword}#{step.to_s}"
            mdc_add_step! @step_name
          elsif :before_scenario
            outline_number, outline_example = nil, nil
            if @current_scenario.is_a? ::Cucumber::Core::Gherkin::ScenarioOutline
              outline_example = step.source[3].values
              outline_number  = calculate_outline_id(step)
            end
            mdc_before_scenario! @current_scenario.name, tags_from_test_step(step), outline_number, outline_example
          end
        end
      end

      # #@api private
      # def exception e, _
      #   log.error e
      # end
    end
  end
end