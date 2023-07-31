Given(/^I reset the MDC$/) do
  Log4r::MDC.get_context.each do |key, _|
    Log4r::MDC.remove key
  end
end

Given(/^I have the following environment variables$/) do |table|
  table.headers.each do |header|
    table.map_column header do |value|
      value == 'nil' ? nil : value
    end
  end


  table.hashes.each do |line|
    line.each do |key, value|
      override_env key, value
      set_environment_variable(key, value)
    end
  end
end

When(/^I register Jenkins variables$/) do
  QAT::Jenkins.register_vars
end

Then(/^the MDC has the values$/) do |table|
  table.headers.each do |header|
    table.map_column header do |value|
      value == 'nil' ? nil : value
    end
  end

  table.hashes.each do |line|
    line.each do |key, value|
      assert_equal value, Log4r::MDC.get_context[key]
    end
  end
end

When(/^I load the "([^"]*)" file$/) do |file|
  load File.join(Dir.pwd, '..', 'lib', file)
end

Then(/^the "([^"]*)" constant is (un)?defined$/) do |const, negated|
  if negated
    refute QAT.const_defined?(const)
  else
    assert QAT.const_defined?(const)
  end
end

When(/^I register Jenkins variables with options$/) do |table|
  opts = {}
  table.headers.each do |header|
    opts.store header.to_sym, []
  end

  table.hashes.each do |line|
    line.each do |key, value|
      opts[key.to_sym] << value
    end
  end

  QAT::Jenkins.register_vars opts
end