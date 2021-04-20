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
      def initialize(config)
        @config = config
        @io     = ensure_io(config.out_stream, config.error_stream)
        ensure_outputter config.out_stream
        @ast_lookup     = ::Cucumber::Formatter::AstLookup.new(config)
        @feature_hashes = []
        config.on_event :test_case_started, &method(:on_test_case_started)
        config.on_event :test_case_finished, &method(:on_test_case_finished)
        config.on_event :test_step_started, &method(:on_test_step_started)
        config.on_event :test_step_finished, &method(:on_test_step_finished)
        config.on_event :test_run_finished, &method(:on_test_run_finished)
      end

      def build (test_case, ast_lookup)
        @background_hash = nil
        uri              = test_case.location.file
        feature          = ast_lookup.gherkin_document(uri).feature
        feature(feature, uri)
        background(feature.children.first.background) unless feature.children.first.background.nil?
        scenario(ast_lookup.scenario_source(test_case), test_case)
      end

      def on_test_case_started event
        return if @config.dry_run?
        @row_number = nil
        test_case   = event.test_case
        build(test_case, @ast_lookup)
        unless @current_feature
          @current_feature = @feature_hash
          mdc_before_feature! @current_feature[:name]
        end

        @current_scenario = @scenario
        mdc_before_scenario! @current_scenario[:name], @current_scenario[:tags], @row_number, @examples_values
      end

      def on_test_case_finished event
        return if @config.dry_run?
        _test_case, result = *event.attributes
        @current_feature = nil
        if result.failed?
          mdc_add_step! @mdc_text
          mdc_add_status_failed!
          log.error { result.exception }
        else
          log.info "Step Done!"
        end
        #  log.error { result.exception }if result.failed?
        log.info { "Finished #{@current_scenario[:keyword]}: \"#{@current_scenario[:name]}\" - #{result}\n" }
      end

      def on_test_step_started(event)
        return if @config.dry_run?
        @test_step       = event.test_step
        return if @test_step.location.file.include?('lib/qat/cucumber/')
        return if @test_step.location.file.include?('features/support/hooks')
        step_source = @ast_lookup.step_source(event.test_step).step
        log.info { "Step \"#{@test_step.text}\"" }
        @mdc_text = "#{step_source.keyword}#{@test_step.text}"
        mdc_add_step!  @mdc_text

      end

      def on_test_step_finished(event)
        return if @config.dry_run?
        test_step, result = *event.attributes
        return if test_step.location.file.include?('lib/qat/cucumber/')
        return if test_step.location.file.include?('features/support/hooks')
        log.info "Step Done!"
      end

      def on_test_run_finished _event
        return if @config.dry_run?
        log.info "Finished #{@feature_hash[:keyword]}: #{@feature_hash[:name]}"
        mdc_after_feature!
      end

      private

      def background(background)
        @background_hash = {
          keyword:     background.keyword,
          name:        background.name,
          description: background.description.nil? ? '' : background.description,
          line:        background.location.line,
          type:        'background'
        }
      end


      def feature (feature, uri)
        @feature_hash = {
          id:          feature.name,
          uri:         uri,
          keyword:     feature.keyword,
          name:        feature.name,
          description: feature.description.nil? ? '' : feature.description,
          line:        feature.location.line
        }
        return if feature.tags.empty?
        tags_array = []
        feature.tags.each { |tag| tags_array << tag.name }
        @feature_hash[:tags] = tags_array
      end

      def scenario(scenario_source, test_case)
        scenario  = scenario_source.type == :Scenario ? scenario_source.scenario : scenario_source.scenario_outline
        @scenario = {
          id:          "#{@feature_hash[:id]};#{create_id_from_scenario_source(scenario_source)}",
          keyword:     scenario.keyword,
          name:        test_case.name,
          description: scenario.description.nil? ? '' : scenario.description,
          line:        test_case.location.lines.max,
          type:        'scenario'
        }
        return if test_case.tags.empty?
        tags_array = []
        test_case.tags.each { |tag| tags_array << tag.name }
        @scenario[:tags] = tags_array
      end

      def create_id_from_scenario_source(scenario_source)
        if scenario_source.type == :Scenario
          scenario_source.scenario.name
        else
          @examples_values = []
          scenario_outline_name = scenario_source.scenario_outline.name
          examples_name         = scenario_source.examples.name
          get_example_values scenario_source
          @row_number = calculate_row_number(scenario_source)
          "#{scenario_outline_name};#{examples_name};#{@row_number}"
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
            row[:cells].each do |data|
              @examples_values << data[:value].to_s
            end
          end
          @examples_values
        end
      end
    end
  end
end