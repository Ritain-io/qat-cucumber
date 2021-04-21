require 'fileutils'
require 'cucumber/formatter/console'
require 'cucumber/formatter/io'
require 'cucumber/formatter/ast_lookup'
require 'cucumber/gherkin/formatter/escaping'
require 'cucumber/deprecate'
require 'qat/logger'
require_relative 'helper'
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
      include ::Cucumber::Formatter
      include QAT::Formatter::Loggable
      include QAT::Logger
      include QAT::Formatter::Helper

      def initialize(config)
        @config         = config
        @io             = ensure_io(config.out_stream, config.error_stream)
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