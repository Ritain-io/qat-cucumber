# -*- encoding : utf-8 -*-
require 'minitest'
require 'cucumber'
require_relative 'version'
require 'qat/logger'

module QAT
  module Cucumber
    #Cucumber World utility. Will be automatically included in the World object when this file is required.
    #Includes MiniTest and a Logger utility.
    #In order to define the Logger channel, a World Class should be defined by the user.
    #Should be required in the env.rb file.
    module World
      include QAT::Logger
      include Minitest::Assertions

      attr_accessor :assertions

      # @!attribute assertions
      #   @return [Integer] Counter of assertions for Minitest integration.
      def assertions
        @assertions ||= 0
      end

      def test_id
        QAT[:current_test_id]
      end

      def test_run_id
        QAT[:current_test_run_id]
      end

      def evidence_prefix
        QAT[:current_test_run_id]
      end

    end
  end
end

