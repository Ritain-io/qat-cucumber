require 'cucumber/formatter/io'
require 'json'

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

      #@api private
      def initialize(runtime, path_or_io, options)
        @io                           = ensure_io(path_or_io)
        @tags                         = []
        @scenario_tags                = []
        @total_scenarios              = 0
        @total_scenarios_without_tags = 0
        @scenarios_without_tags       = {}
        @options                      = options
      end

      #@api private
      def after_features(features)
        publish_result
      end

      #@api private
      def before_feature(feature)
        @feature_tags = []
        @in_scenarios = false
      end

      #@api private
      def tag_name(tag_name)
        if @in_scenarios
          @scenario_tags << tag_name unless tag_name.match(/@test#(\d+)/)
        else
          @feature_tags << tag_name
        end
      end

      #@api private
      def after_tags(tags)
        @in_scenarios = true unless @in_scenarios
      end

      #@api private
      def scenario_name(keyword, name, file_colon_line, source_indent)
        scenario_tags    = @scenario_tags + @feature_tags
        @tags            += scenario_tags
        @total_scenarios += 1
        unless scenario_tags.any?
          @scenarios_without_tags[name] = file_colon_line
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
        @io.Kernel.puts(content.to_json({
                                   indent:    ' ',
                                   space:     ' ',
                                   object_nl: "\n"
                                 }))
      end
    end
  end
end