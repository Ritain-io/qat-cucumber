@epic#198 @feature#219 @user_story#228 @announce
Feature: Feature #219: CLI for project control: User Story #228: CLI utility basic command listing and version
  In order to easily use the CLI utility
  As a test developer
  I want to list all options and its usage and the current version

  @test#27
  Scenario Outline: Show version
    When I successfully run `qat <command>`
    Then the exit status should be 0
    And the stdout should contain the value for QAT::Cucumber::VERSION
    Examples:
      | command   |
      | -v        |
      | --version |

  @test#28
  Scenario Outline: Show help
    When I successfully run `qat <command>`
    Then the exit status should be 0
    And the stdout should contain:
      """
      Usage: qat [OPTIONS]
      Options
          -n, --new [NAME]                 Create new project
          -a, --add [MODULES]              Integrate modules in project
          -l, --list                       Show available modules
          -r, --verbose                    Show detailed information
          -v, --version                    Show QAT-Cucumber version
          -h, --help                       Show this helper
      """
    Examples:
      | command |
      | -h      |
      | --help  |
      |         |
