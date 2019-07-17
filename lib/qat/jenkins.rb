# -*- encoding : utf-8 -*-

require 'qat/logger'
require_relative 'cucumber/version'

module QAT

  #Jenkins helper. Should be required by the Cucumber module then running tests in a Jenkins server.
  #@since 0.1.0
  module Jenkins

    #Default Jenkins environment variables to add register in the +QAT::Logger+.
    DEFAULT_ENV_VARS = [
      'BUILD_NUMBER',
      'BUILD_URL',
      'NODE_NAME',
      'JOB_NAME',
      'SVN_REVISION',
      'GIT_COMMIT'
    ]


    #Register Jenkins environment variables in the Log4r::MDC hash.
    #By default only the {DEFAULT_ENV_VARS} will be registered.
    #@param [Hash] opts Options to modify default registry
    #@option opts [Array<String>] :ignore ([]) List of default environment variables to ignore.
    #@option opts [Array<String>] :add ([]) List of non default environment variables to add.
    #@since 0.1.0
    #@see http://log4r.rubyforge.org/rdoc/log4r/rdoc/MDC.html Log4r MDC
    def self.register_vars(opts={})
      ignore_list = opts[:ignore] || []
      add_list    = opts[:add] || []

      list = DEFAULT_ENV_VARS + add_list - ignore_list

      list.each do |var|
        Log4r::MDC.put var, ENV[var] if ENV[var]
      end

    end

  end
end