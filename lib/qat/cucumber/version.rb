#encoding: utf-8

#QAT Module works as a namespace for all sub modules.
#Some singleton methods are also available, as defined by various sub classes.
#@since 0.1.0
module QAT
  # Namespace for various helpers when running with cucumber.
  #Just require 'qat/cucumber' to automatically integrate all the available helpers.
  #
  #@since 0.1.0
  module Cucumber
    # Represents QAT's version
    VERSION = '7.0.0'
  end
end