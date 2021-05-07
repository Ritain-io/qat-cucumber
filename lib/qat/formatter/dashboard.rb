require 'fileutils'
require 'cucumber/formatter/console'
require 'cucumber/formatter/io'
require 'cucumber/gherkin/formatter/escaping'
require 'qat/logger'
require_relative 'loggable'
require 'cucumber/core/gherkin/writer'
require_relative 'helper'

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
      include QAT::Formatter::Helper

      #@api private
      def initialize(config)
        @config = config
        @io     = ensure_io(config.out_stream, config.error_stream)
        ensure_outputter 'Dashboard' unless @config.dry_run?
        @ast_lookup     = ::Cucumber::Formatter::AstLookup.new(config)
        @feature_hashes = []
        config.on_event :test_case_started, &method(:on_test_case_started)
        config.on_event :test_case_finished, &method(:on_test_case_finished)
        config.on_event :test_step_started, &method(:on_test_step_started)
        config.on_event :test_step_finished, &method(:on_test_step_finished)
        config.on_event :test_run_finished, &method(:on_test_run_finished)
      end

    end
  end
end