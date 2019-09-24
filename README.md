[![Build Status](https://travis-ci.org/readiness-it/qat-cucumber.svg?branch=master)](https://travis-ci.org/readiness-it/qat-cucumber)

# QAT::Cucumber

- Welcome to the QAT Cucumber gem!

- This gem support different types of features to 
quickest start a new project, log the failures and help with maintenance of the project:
  - **Log all test failures;**
  - **Command line interface to list all options;**
  - **Rake tasks validations;**

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'qat-cucumber'
```
And then execute:
 
    $ bundle install
 
Or install it yourself as:
 
    $ gem install qat-cucumber
 
 # Usage
**Log all test failures** - This feature allows user to log test failures to a dashboard or in the console at a specific format, set with an environment variable. 

**Command line interface to list all options** - List all possible commands. Allows to create a new project using the command line interface utility with the basic folder structure to start a new project and default configurations.
List all toolkit's installed modules and add modules to the project.

##### Command Line (CLI) usage examples:
```bash
qat --version
qat --help
qat --list
qat --new
qat -n new_project --verbose
``` 

**Rake tasks validations** - Rake tasks are usually administration tasks, to validate information or generate necessary fields to your code. Qat Cucumber have tasks to: 

- **Run all test scenarios;**
- **Run a complete feature of tests;**
- **Run scenarios containing a given tag;**
- **Generate test ids for scenarios;**
- **Automatic validate step defenitions;**
- **List scenarios by tag;**
- **List scenarios with the same name;**
- **List all scenarios without tags;**

##### Command Line (CLI) usage examples:
```bash
rake qat:test:run
rake qat:test:feature[example1]
rake qat:test:tags[@tagged_feature]
rake qat:tags:report_test_ids
rake qat:steps:validation
rake qat:list:by_tag[@qat]
rake qat:list:dup_names
rake qat:list:untagged
``` 

# Documentation

- [API documentation](https://readiness-it.github.io/qat-cucumber/)


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/readiness-it/qat-cucumber. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the QAT::Cucumber project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/readiness-it/qat-cucumber/blob/master/CODE_OF_CONDUCT.md).
