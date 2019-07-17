require 'qat/logger'
require_relative 'loggable/mdc'

module QAT
  #Namespace for custom Cucumber formatters and helpers.
  #@since 0.1.0
  module Formatter
    #Helper module to manage formatters based on QAT::Logger
    #@since 0.1.0
    module Loggable
      include QAT::Logger
      include Mdc

      def check_outputter name
        return if name.respond_to? :write #Is an IO

        add_outputter_with name
      end


      def ensure_outputter name
        raise ArgumentError.new "No outputter configured for formatter #{self.class.name}" if name.respond_to? :write

        add_outputter_with name
      end

      #Parses a test step and determines it's type: after step, before scenario or before step.
      #Allows a block to be used to execute in the middle of the processing
      #@param step [Cucumber::Core::Test::Step] Step to parse
      #@yield [type] Block to execute in the middle of processing
      #@yieldparam [Symbol] type Type of the test step
      #@return [Symbol] type Type of the test step
      #@since 0.1.0
      def begin_test_step step
        #World: step.location = /usr/local/rvm/gems/ruby-2.2.3/gems/cucumber-2.0.2/lib/cucumber/filters/prepare_world.rb:27
        # step.name = "Before hook"

        #Hooks: step.location = /home/mgomes/Projects/qat/src/qat/lib/qat/cucumber/hooks.rb:53
        # step.name = "Before hook"

        #Stepdef: step.location = features/formatter.feature:8
        # step.name = step name

        type = set_type(step)

        yield type if block_given? and type

        set_step_status(type)

        type
      end

      private

      def add_outputter_with(name)
        require_relative '../cucumber'

        outputter = Log4r::Outputter[name]

        raise ArgumentError.new "No outputter in loaded configuration file with name #{name}" unless outputter

        return if log.outputters.map(&:name).include? name

        log.add outputter
      end

      def set_type(step)
        location  = step.location.file.to_s
        step_name = step.name

        if step_name == "After hook"
          :after_step
        elsif step_name == "Before hook" and location.end_with? 'prepare_world.rb'
          @current_scenario = step.source[1]
          :before_scenario
        elsif File.extname(location.to_s) == '.feature'
          :before_step
        end
      end

      def set_step_status(type)
        if type == :after_step
          @step_running = false
        elsif type == :before_scenario
          @step_running = false
        elsif type == :before_step
          @step_running = true
        end
      end
    end
  end
end