@epic#198 @feature#219 @user_story#231 @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Feature #219: CLI for project control: User Story #231: Integrate modules in a test project
  In order to integrate a toolkit module in a test project
  As a test developer
  I want to automatically do it using the CLI utility


  Background: Install gem
    Given the "qat" gem is installed


  @test#38
  Scenario Outline: Add a module
    Given I copy the directory named "../../resources/qat_project" to "my_project"
    And I cd to "my_project"
    When I run `qat <command> core`
    Then the exit status should be 0
    And the stdout should contain "Module core added to my_project"
    Examples:
      | command |
      | -a      |
      | --add   |


  @test#39
  Scenario: Add list of modules
    Given the "logger" gem is installed
    And I copy the directory named "../../resources/qat_project" to "my_project"
    And I cd to "my_project"
    When I run `qat -a core,logger`
    Then the exit status should be 0
    And the stdout should contain "Module core added to my_project"


  @test#40
  Scenario: Verbose output when adding module
    Given I copy the directory named "../../resources/qat_project" to "my_project"
    And I cd to "my_project"
    When I run `qat -a core -r`
    Then the exit status should be 0
    And the stdout should contain:
    """
    Adding module core
    Nothing to add in Core module
    Module core added to my_project
    """


  @test#41 @bug#1345
  Scenario: Create project and add modules
    When I run `qat -n new_project -a core`
    Then the exit status should be 0
    And a directory named "new_project" should exist
    And the stdout should contain "Module core added to new_project"


  @test#42
  Scenario Outline: Add nonexistent modules
    Given I copy the directory named "../../resources/qat_project" to "my_project"
    And I cd to "my_project"
    When I run `qat -a <module>`
    Then the exit status should be 1
    And the stderr should contain "<error_message>"
    Examples:
      | module                   | error_message                               |
      | nonexistent              | Error: Module nonexistent missing!          |
      | nonexistent,unknown      | Error: Modules nonexistent,unknown missing! |
      | nonexistent,core         | Error: Module nonexistent missing!          |
      | core,nonexistent,unknown | Error: Modules nonexistent,unknown missing! |

