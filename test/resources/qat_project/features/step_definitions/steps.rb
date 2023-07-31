Given(/^true$/) do
  assert true
end

Given (/^false$/) do
 assert false
end

Given (/^pending$/) do
  log.debug "pending"
  Kernel.puts "pending"
  pending
end

Given(/^I caught (\d+) red balls$/) do |balls|
  @value= balls
end

Then(/^i have (\d+) red balls$/) do |arg|
 assert_equal arg , @value , "Value isn't equal"
end

Given /^log "([^"]*)"$/ do |text|
  log.info text
end

When /^I access the value of "([^"]*)" in "([^"]*)" yml file$/ do |value, file|
  @value = QAT.configuration[file][value]
end

When /^I access the value of the environment name$/ do
  @value = QAT.configuration.environment
end

Then /^the value is "([^"]*)"$/ do |value|
  assert_equal value, @value
end

When /^I save "([^"]*)" in core with key "([^"]*)"( with persistence)?$/ do |value, key, persistance|
  key = key.to_sym
  if persistance
    QAT.store_permanently key, value
  else
    QAT.store key, value
  end
end

Then /^the value in core for "([^"]*)" is (?:"(.*)"|(empty))$/ do |key, value, empty|
  key = key.to_sym
  if empty
    refute QAT[key]
  elsif key == :test_start_timestamp
    assert_equal Time.parse(value), QAT[key]
  else
    assert_equal value, QAT[key].to_s
  end
end

Given /^I freeze the clock at "([^"]*)"$/ do |time|
  Timecop.freeze time
end

Given /^I reset the clock$/ do
  Timecop.return
end

Given /^I save a "([^"]*)" file in tmp folder$/ do |file|
  File.new File.join(QAT[:tmp_folder], file), 'w'
end

Given /^there is(n't| not)? a "([^"]*)" file in tmp folder$/ do |negated, file|
  exists = File.exists? File.join(QAT[:tmp_folder], file)

  if negated
    refute exists
  else
    assert exists
  end
end

Then(/^the MDC has the values$/) do |table|
  table.headers.each do |header|
    table.map_column header do |value|
      if value == 'nil'
        nil
      else

        if ['tags', 'outline_example'].include? header and value
          value = value.split ','
        end

        value = value.to_i if header == 'outline_number'

        value
      end
    end
  end

  table.hashes.each do |line|
    line.each do |key, value|
      log.debug "Key '#{key}' - Expected '#{value}', Actual '#{Log4r::MDC.get_context[key]}'"
      assert_equal value, Log4r::MDC.get_context[key]
    end
  end
end