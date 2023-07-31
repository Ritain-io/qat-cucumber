# -*- encoding : utf-8 -*-
require 'minitest'
require "active_support"
require 'active_support/core_ext/date_time/calculations'
require 'active_support/core_ext/time/calculations'
require 'active_support/core_ext/date/calculations'
require 'aruba/cucumber'
require 'retriable'
require 'httparty'
require 'nokogiri'
# Code coverage
require 'simplecov'

old_jenkins_url = ENV['JENKINS_URL']

at_exit do
  ENV['JENKINS_URL'] = old_jenkins_url
end

ENV['JENKINS_URL'] = nil

require_relative '../../../lib/qat/cucumber'
require_relative '../../lib/core_helper'
require_relative '../../lib/configuration_helper'

module Test
  include QAT::Logger
  include Minitest::Assertions

  attr_writer :assertions

  def assertions
    @assertions ||= 0
  end
end
World(Test)

#Variable activated by the raketask "qat:logger:run_tests_with_debug"
if $log4r_debugger
  Kernel.puts 'Log4r internal logger activated!!'
  Log4r::Logger.new 'log4r'
  Log4r::Logger['log4r'].outputters= Log4r::Outputter.stderr
end


Aruba.configure do |config|
  config.command_search_paths = config.command_search_paths << ::File.absolute_path(::File.join(::File.dirname(__FILE__), '..', '..', '..', 'bin'))
  config.exit_timeout         = 6000
end