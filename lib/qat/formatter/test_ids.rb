require 'cucumber/formatter/io'
require 'json'
require_relative 'helper'

module QAT
  module Formatter
    # Formatter to get duplicate test ids and get scenarios untagged
  class TestIds
      include Cucumber::Formatter::Io
      include QAT::Formatter::Helper

      def initialize(config)
        @config             = config
        @no_test_id         = {}
        @max_test_id        = 0
        @duplicate_test_ids = {}
        @test_id_mapping    = {}
        @io                 = ensure_io(config.out_stream, config.error_stream)
        @ast_lookup         = ::Cucumber::Formatter::AstLookup.new(@config)
        config.on_event :test_case_started, &method(:on_test_case_started)
        config.on_event :test_run_finished, &method(:on_test_run_finished)

      end


      #@api private
      def on_test_case_started event
        @feature_hashes     = []
        @tags               = []
        @scenario_tags      = []
        @examples_values = []
        build(event.test_case, @ast_lookup)
        @current_feature = @feature_hash
        scenario_name
      end

      def on_test_run_finished(_event)
        publish_result
        @io.flush
      end

      def scenario_name
       path = "#{@current_feature[:uri]}:#{@scenario[:line]}"
       scenario_tags= @scenario[:tags]
        if scenario_tags.any? { |tag| tag.match(/@test#(\d+)/) }
          id           = scenario_tags.map { |tag| tag.match(/@test#(\d+)/) }.compact.first.captures.first.to_i
          @max_test_id = id if id > @max_test_id

          test_id_info = { name: @scenario[:name],
                           path:  path}

          if @test_id_mapping[id]
            if @duplicate_test_ids[id]
              @duplicate_test_ids[id].find do |dup|
                @exist = true if dup[:path]== test_id_info[:path]
              end
              @duplicate_test_ids[id] << test_id_info unless @exist
            else
              @duplicate_test_ids[id] = [@test_id_mapping[id], test_id_info] unless @test_id_mapping[id][:path] == test_id_info[:path]
            end
          else
            @test_id_mapping[id] = test_id_info
          end
        else
          @no_test_id[@scenario[:name]] = path unless scenario_tags.include?('@dummy_test')
        end
        @scenario[:tags] = []
      end

      private

      def publish_result
        content = {
          max:       @max_test_id,
          untagged:  @no_test_id,
          mapping:   Hash[@test_id_mapping.sort],
          duplicate: Hash[@duplicate_test_ids.sort]
        }

        if @duplicate_test_ids.any?
          dups_info = @duplicate_test_ids.map do |id, dups|
            text = dups.map { |dup| "Scenario: #{dup[:name]} - #{dup[:path]}" }.join("\n")
            "TEST ID #{id}:\n#{text}\n"
          end

          duplicates_info = <<-TXT.gsub(/^\s*/, '')
          ------------------------------------
          Duplicate test ids found!
          ------------------------------------
          #{dups_info.join("\n")}
          TXT
          Kernel.puts duplicates_info
        end

        @io.write (JSON.pretty_generate(content))
      end



    end
  end
end