require 'cucumber/formatter/junit'

module Cucumber
  module Formatter
    # The formatter used for <tt>--format junit</tt>
    class Junit

      #Method to parse time in testsuite elements
      def end_feature(feature_data)
        @testsuite = Builder::XmlMarkup.new(:indent => 2)
        @testsuite.instruct!
        @testsuite.testsuite(
          :failures => feature_data[:failures],
          :errors   => feature_data[:errors],
          :skipped  => feature_data[:skipped],
          :tests    => feature_data[:tests],
          :time     => "%.3f" % feature_data[:time],
          :name     => feature_data[:feature].name) do
          @testsuite << feature_data[:builder].target!
        end

        write_file(feature_result_filename(feature_data[:feature].file), @testsuite.target!)
      end

      #Method to parse time in testcase elements
      def build_testcase(result, scenario_designation, output)
        duration = ResultBuilder.new(result).test_case_duration
        @current_feature_data[:time] += duration
        classname = @current_feature_data[:feature].name
        name = scenario_designation

        @current_feature_data[:builder].testcase(:classname => classname, :name => name, :time => "%.3f" % duration) do
          if !result.passed? && result.ok?(@config.strict)
            @current_feature_data[:builder].skipped
            @current_feature_data[:skipped] += 1
          elsif !result.passed?
            status = result.to_sym
            exception = get_backtrace_object(result)
            @current_feature_data[:builder].failure(:message => "#{status} #{name}", :type => status) do
              @current_feature_data[:builder].cdata! output
              @current_feature_data[:builder].cdata!(format_exception(exception)) if exception
            end
            @current_feature_data[:failures] += 1
          end
          @current_feature_data[:builder].tag!('system-out') do
            @current_feature_data[:builder].cdata! strip_control_chars(@interceptedout.buffer_string.join)
          end
          @current_feature_data[:builder].tag!('system-err') do
            @current_feature_data[:builder].cdata! strip_control_chars(@interceptederr.buffer_string.join)
          end
        end
        @current_feature_data[:tests] += 1
      end
    end
  end
end

