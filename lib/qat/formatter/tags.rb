require 'cucumber/formatter/io'
require 'json'
require_relative 'helper'

module QAT
  module Formatter
    # This formatter prints test scenarios tags information to a JSON format.
    # Information includes:
    # - untagged test scenarios
    # - list of unique tags used
    # - total number of tags used
    #
    # Note: Generated test ids are omitted.
    #
    class Tags
      include Cucumber::Formatter::Io
      include QAT::Formatter::Helper

      #@api private
      def initialize(config)
        @config = config
        @io     = ensure_io(config.out_stream, config.error_stream)
        @tags                         = []
        @scenario_tags                = []
        @total_scenarios              = 0
        @total_scenarios_without_tags = 0
        @scenarios_without_tags       = {}
        @ast_lookup     = ::Cucumber::Formatter::AstLookup.new(config)
        @feature_hashes = []
        config.on_event :test_case_started, &method(:on_test_case_started)
        config.on_event :test_run_finished, &method(:on_test_run_finished)
      end



      def on_test_case_started event
        @feature_tags = []
        @examples_values = []
        test_case        = event.test_case
        build(test_case, @ast_lookup)
        @current_feature = @feature_hash
        @test_id_tags = true
        scenario_name
      end

      def on_test_run_finished(_event)
        publish_result
      end


      #@api private
      def scenario_name
        scenario_tags    = @scenario[:tags] +  @feature_hash[:tags] if @scenario[:tags] &&  @feature_hash[:tags] rescue nil
        @tags            += scenario_tags unless scenario_tags.nil?
        @total_scenarios += 1
        unless scenario_tags.try(:any?)
          @scenarios_without_tags[@scenario[:name]] = "#{@current_feature[:uri]}:#{@scenario[:line]}"
          @total_scenarios_without_tags += 1
        end
        @scenario_tags = []
      end

      private
      def publish_result
        content = {
          untagged: @scenarios_without_tags,
          tags:
                    { unique: @tags.uniq.sort,
                      total:  @tags.size }
        }
        @io.write (JSON.pretty_generate(content))
      end



    end
  end
end