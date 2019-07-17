Given /^true$/ do
    assert true
end

Given /^false$/ do
  assert false
end


Then(/^The test id should be "([^"]*)"$/) do |arg|
  assert_equal arg, test_id, "The expected id should be #{arg} and the resolved was #{test_id}"
end

And(/^the test run id is correctly defined$/) do
  assert_equal("#{test_id}_#{QAT[:test_start_timestamp].to_i}",test_run_id, "The expected timestamp should be #{test_run_id} and the resolved was #{test_id}_#{QAT[:test_start_timestamp].to_i} ")
end

And(/^the evidence prefix is correctly defined$/) do
  assert_equal(evidence_prefix, test_run_id, "The expected evidence prefix should be #{test_run_id} and the resolved was #{evidence_prefix}")
end