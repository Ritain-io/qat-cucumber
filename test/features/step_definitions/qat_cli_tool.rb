Given(/^I have qat installed$/) do
  #log.info { 'I checked that qat is installed' }
  output = %x(which qat)
  assert_equal('/opt/ptin/ruby/bin/qat', output.strip)
end

When(/^I run the 'qat' command without arguments$/) do
  @output = %x(qat)
  log.info { "Output: '#{@output}'" }
end

Then(/^'qat' returns the script helper$/) do
  assert_equal("Usage", @output.strip[0, 5])
  log.info { "Output: '#{@output}'" }
end


When(/^I run the 'qat' command with option "(.*?)"$/) do |option|
  @output = %x(qat #{option})
end


When(/^I run the 'qat' command with the \-\-new option without providing other argument$/) do
  old_path     = Dir.pwd
  working_path = File.join(File::SEPARATOR, 'tmp')
  begin
    Dir.chdir(File.expand_path(working_path))

    command = 'qat --new'
    log.info { "Executing '#{command}'." }
    @output = %x(#{command})

  ensure
    Dir.chdir(old_path)
  end
  log.info { "Output: '#{@output}'" }
end

Then(/^'qat' returns the error$/) do |exp_error|
  assert_equal(exp_error, @output.strip)
end

Then(/^'qat' returns the error "(.*?)"$/) do |exp_error|
  assert_equal(exp_error, @output.strip)
end

When(/^I run the 'qat' command with the \-\-new option providing "(.*?)"$/) do |option|
  old_path     = Dir.pwd
  working_path = File.join(File::SEPARATOR, 'tmp')
  begin
    Dir.chdir(File.expand_path(working_path))

    @argument = option.split(' ')
    @output   = %x(qat --new #{option})

  ensure
    Dir.chdir(old_path)
  end
end

Then(/^I have a new project folder named after the first valid argument$/) do
  old_path     = Dir.pwd
  working_path = File.join(File::SEPARATOR, 'tmp')
  begin
    Dir.chdir(File.expand_path(working_path))

    log.info { @output }
    path = File.join(File.expand_path(working_path), @argument.first)
    QAT::ProjectStructure.check_project_folder(path)
  ensure
    Dir.chdir(old_path)
  end
end

Then(/^'qat' returns the information:$/) do |exp_info|
  assert_equal(exp_info, @output.strip)
end

Then(/^'qat' returns the information: "(.*?)"$/) do |exp_info|
  assert_equal(exp_info, @output.strip)
end

When(/^I run the 'qat' command with the \-n option without providing other argument$/) do
  @output = %x(qat -n)
end

When(/^I run the 'qat' command with the \-n option providing "(.*?)"$/) do |option|
  old_path     = Dir.pwd
  working_path = File.join(File::SEPARATOR, 'tmp')
  begin
    Dir.chdir(File.expand_path(working_path))

    @argument = option.split(' ')
    @output   = %x(qat --new #{option})

  ensure
    Dir.chdir(old_path)
  end
end


When(/^I run the 'qat' command with the \-\-verbose option$/) do
  @output = %x(qat --verbose)
end

Then(/^'qat' does nothing$/) do
  log.info { "Output: '#{@output.strip}'" }
  assert_equal('', @output.strip)
end

When(/^I run the 'qat' command with the \-\-verbose option providing "(.*?)"$/) do |argument| #######################
  old_path     = Dir.pwd
  working_path = File.join(File::SEPARATOR, 'tmp')
  begin
    Dir.chdir(File.expand_path(working_path))

    @argument = argument.split(' ')
    @output   = %x(qat --verbose #{argument})
  ensure
    Dir.chdir(old_path)
  end
end

Then(/^'qat' returns the generator logs$/) do
  assert_equal("Creating new project 'name1'\nProject 'name1' was successfully created!".strip, @output.strip)
end

Then(/^I have a new project named after the last argument$/) do
  old_path     = Dir.pwd
  working_path = File.join(File::SEPARATOR, 'tmp')
  begin
    Dir.chdir(File.expand_path(working_path))

    log.info { @output }
    path                    = File.join(File.expand_path(working_path), @argument.last)
    QAT::Config.config_path = path
    QAT::Config.send(:config_folder?)

  ensure
    Dir.chdir(old_path)
  end
end


When(/^I run the 'qat' command with the \-r option$/) do
  @output = %x(qat -r)
end

When(/^I run the 'qat' command with the \-r option providing "(.*?)"$/) do |argument|
  old_path     = Dir.pwd
  working_path = File.join(File::SEPARATOR, 'tmp')
  begin
    Dir.chdir(File.expand_path(working_path))

    @argument = argument.split(' ')
    @output   = %x(qat --verbose #{argument})
  ensure
    Dir.chdir(old_path)
  end
end


When(/^I run the 'qat' command with the \-\-version option$/) do
  @output = %x(qat --version)
end

Then(/^'qat' returns its version$/) do
  log.info { "Output: '#{@output.strip}'" }
  assert(@output.strip.match(/qat \(\d+\.\d+\.\d+\)/))
end

When(/^I run the 'qat' command with the \-\-version option providing "(.*?)"$/) do |argument|
  #arg1 might have two arguments.
  @argument = argument.split(' ')
  @output   = %x(qat --version #{argument})
end

When(/^I run the 'qat' command with the \-v option$/) do
  @output = %x(qat -v)
end

When(/^I run the 'qat' command with the \-v option providing "(.*?)"$/) do |argument|
  #arg1 might have two arguments.
  @argument = argument.split(' ')
  @output   = %x(qat -v #{argument})
end


When(/^I run the 'qat' command with the \-\-help option$/) do
  @output = %x(qat --help)
end

When(/^I run the 'qat' command with the \-\-help option providing "(.*?)"$/) do |argument|
  #arg1 might have two arguments.
  @argument = argument.split(' ')
  @output   = %x(qat --help #{argument})
end

When(/^I run the 'qat' command with the \-h option$/) do
  @output = %x(qat -h)
end

When(/^I run the 'qat' command with the \-h option option providing "(.*?)"$/) do |argument|
  #arg1 might have two arguments.
  @argument = argument.split(' ')
  @output   = %x(qat -h #{argument})
end

Given(/^I am inside a project folder$/) do
  old_path     = Dir.pwd
  working_path = File.join(File::SEPARATOR, 'tmp')
  begin
    Dir.chdir(File.expand_path(working_path))

    @output = %x(qat --new name1)

  ensure
    Dir.chdir(old_path)
  end
end

When(/^I run the 'qat' command with the \-\-integrate option$/) do
  old_path     = Dir.pwd
  working_path = File.join(File::SEPARATOR, 'tmp', 'name1')
  begin
    Dir.chdir(File.expand_path(working_path))
    @output = %x(qat --integrate)
  ensure
    Dir.chdir(old_path)
  end
  log.info { "Output: '#{@output}'" }
end

When(/^I run the 'qat' command with the \-\-integrate option providing "(.*?)"$/) do |module_list|
  old_path     = Dir.pwd
  working_path = File.join(File::SEPARATOR, 'tmp', 'name1')
  begin
    Dir.chdir(File.expand_path(working_path))

    @passed_modules = module_list.split(' ')
    @output         = %x(qat --integrate #{module_list})

  ensure
    Dir.chdir(old_path)
  end
  log.info { "Output: '#{@output}'" }
end

Then(/^I have all modules integrated in the target project$/) do
  old_path     = Dir.pwd
  working_path = File.join(File::SEPARATOR, 'tmp', 'name1')
  begin
    Dir.chdir(File.expand_path(working_path))

    result = @passed_modules.all? do |passed_modules|
      log.info { "Testing #{passed_modules}" }
      module_list = passed_modules.split(',')
      module_list.all? do |passed_module|
        QAT::ModuleValidator.validate(passed_module)
      end
    end

  ensure
    Dir.chdir(old_path)
  end
  assert(result)
end


Then(/^I have the module integrated in the target project$/) do
  step('I have all modules integrated in the target project')
end

When(/^I run the 'qat' command with the \-i option$/) do
  old_path     = Dir.pwd
  working_path = File.join(File::SEPARATOR, 'tmp', 'name1')
  begin
    Dir.chdir(File.expand_path(working_path))

    @output = %x(qat -i)

  ensure
    Dir.chdir(old_path)
  end
  log.info { "Output: '#{@output}'" }
end

When(/^I run the 'qat' command with the \-i option providing "(.*?)"$/) do |module_list|
  old_path     = Dir.pwd
  working_path = File.join(File::SEPARATOR, 'tmp', 'name1')
  begin
    Dir.chdir(File.expand_path(working_path))

    @passed_modules = module_list.split(' ')
    @output         = %x(qat -i #{module_list})

  ensure
    Dir.chdir(old_path)
  end
  log.info { "Output: '#{@output.strip}'" }
end

And(/^the stdout should contain the value for QAT::Cucumber::VERSION$/) do
  commands = all_commands

  if Aruba::VERSION < '1.0'
    combined_output = commands.map do |c|
      c.stop
      c.send(:stdout).chomp
    end.join("\n")
    expect(combined_output).to send(:an_output_string_being_eq, QAT::Cucumber::VERSION)
  else
    expect(commands.first.stdout).to include_output_string QAT::Cucumber::VERSION
  end
end

