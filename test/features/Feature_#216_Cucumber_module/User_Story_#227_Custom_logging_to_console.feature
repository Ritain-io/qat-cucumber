@epic#198 @feature#216 @user_story#227 @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Feature #216: Cucumber module: User Story #227: Custom logging to console
  In order to have more information and better context for a test execution
  As a test developer
  I want to have a custom console formatter

  Background: Create QAT project
    Given I copy the directory named "../../resources/qat_project" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |

  @test#19
  Scenario: Run dummy QAT project with console formatter - check MDC is set
    Given I set the environment variable to:
      | variable      | value                             |
      | CUCUMBER_OPTS | --format QAT::Formatter::Console  |
    When I run `rake mdc_success_tests`
    And the exit status should be 2


  ### QAT Configuration appears on the stoudt
#  @test#20
#  Scenario: Run dummy QAT project with console formatter - check no output in dry run
#    Given I set the environment variable to:
#      | variable      | value                                       |
#      | CUCUMBER_OPTS | --dry-run --format QAT::Formatter::Console  |
#    When I run `rake formatter_tests`
#    Then the stdout should not contain anything
#    And the exit status should be 0

