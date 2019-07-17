

Then /^a "([^"]*)" exception is raised$/ do |klass|
  refute_nil @error
  assert_equal klass, @error.class.to_s
  @error = nil
end

Then /^no exception is raised$/ do
  refute @error
end