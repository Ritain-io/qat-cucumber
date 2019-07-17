# -*- encoding : utf-8 -*-
require 'cucumber'
require 'fileutils'
require 'tmpdir'
require 'qat/time'
require_relative 'version'
require_relative 'hooks/scenario'

module QAT
  module Cucumber
    #Methods to execute with Cucumber Hooks and at_exit.
    #@since 0.1.0
    module Hooks
      include QAT::Logger

      class << self
        #Hook to be executed before a scenario. It executes the following actions:
        # * save scenario tags (Saved in {QAT::Core} with the :scenario_tags key)
        # * save current test start timestamp (Saved in {QAT::Core} with the :test_start_timestamp key)
        # * create a temporary folder (Saved in {QAT::Core} with the :tmp_folder key)
        def before(scenario)
          QAT.reset!

          QAT.store :scenario_tags, Scenario.scenario_tags(scenario)
          QAT.store :test_start_timestamp, QAT::Time.now
          QAT.store :tmp_folder, Dir.mktmpdir

          Scenario.define_test_id(scenario)
        rescue => error
          log.warn { error }
        end

        def after_step
          #TODO
        rescue => error
          log.warn { error }
        end

        #Hook to be executed after a scenario. It executes the following actions:
        # * delete the temporary folder
        # * reset the cache
        def after(_)
          FileUtils.rm_r QAT[:tmp_folder]
        rescue => error
          log.warn { error }
        end

        def at_exit
          #TODO
        rescue => error
          log.warn { error }
        end
      end
    end
  end
end

Before do |scenario|
  QAT::Cucumber::Hooks.before(scenario)
end

AfterStep do
  QAT::Cucumber::Hooks.after_step
end

After do |scenario|
  QAT::Cucumber::Hooks.after(scenario)
end

at_exit do
  QAT::Cucumber::Hooks.at_exit
end