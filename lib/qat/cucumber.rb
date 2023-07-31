# -*- encoding : utf-8 -*-
require "active_support"
require 'minitest'
require 'cucumber'
require_relative 'cucumber/version'
require_relative 'cucumber/core_ext'
require 'qat/logger'
require 'qat/core'
require 'qat/configuration'
require 'qat/time'
require_relative 'jenkins' if ENV['JENKINS_URL']
require_relative 'cucumber/logger'
require_relative 'cucumber/time'

require_relative 'cucumber/hooks'
require_relative 'cucumber/world'
World QAT::Cucumber::World

#QAT Module works as a namespace for all sub modules.
#Some singleton methods are also available, as defined by various sub classes.
#@since 0.1.0
module QAT
  # Namespace for various helpers when running with cucumber.
  #Just require 'qat/cucumber' to automatically integrate all the available helpers.
  #
  #@since 0.1.0
  module Cucumber
    include QAT::Logger

    class << self
      include QAT::Cucumber::Logger
      include QAT::Cucumber::Time

      # Launches the pre-test configurations and integrations
      # This includes:
      # - Time Synchronization between the host running tests
      #   and a target host (test environment?) if configured
      # - Setups the Jenkins integration if running this CI Server
      def launch!
        current_configuration = QAT.configuration

        raise EmptyConfiguration.new "No valid configuration exists to run tests!" unless current_configuration
        raise InvalidConfiguration.new "No valid environment is defined, aborting test execution!" unless current_configuration.environment

        config_logger(current_configuration)

        time_sync if current_configuration[:time]

        setup_jenkins((current_configuration)) if ENV['JENKINS_URL']
      end

      private

      # Initializes the Jenkins configuration for test run
      # @param configuration [Hash] configuration
      def setup_jenkins(configuration)
        jenkins_vars = configuration.dig(:jenkins, :env_vars)

        if jenkins_vars
          QAT::Jenkins.register_vars(jenkins_vars)
        else
          log.debug { "Configuring Jenkins with default options." }
          QAT::Jenkins.register_vars
        end
      end
    end

    # This class represents a empty configuration error when there is no configuration available
    class EmptyConfiguration < StandardError
    end
    # This class represents a invalid configuration error when the configuration is not complete
    class InvalidConfiguration < StandardError
    end
  end
end

QAT::Cucumber.launch!