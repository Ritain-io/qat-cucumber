@epic#198 @feature#216 @user_story#225 @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Feature #216: Cucumber module: User Story #225: Log test failures to Dashboard
  In order to track test failures
  As a tester
  I want all test failures to be logged automatically to a dashboard

  Background: Create QAT project
    Given I copy the directory named "../../resources/qat_project" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |

  @test#16
  Scenario: Run dummy QAT project with dashboard formatter - check no output in dry run
    Given I set the environment variable to:
      | variable      | value                                        |
      | CUCUMBER_OPTS | --dry-run --format QAT::Formatter::Dashboard --out Dashboard |
    When I run `rake formatter_tests`
    And the exit status should be 0

  @test#17
  Scenario: Run dummy QAT project with dashboard formatter - no mandatory output for formatter crashes test run
    Given I set the environment variable to:
      | variable      | value                              |
      | CUCUMBER_OPTS | --format QAT::Formatter::Dashboard  |
    When I run `rake mdc_error_tests`
    And the exit status should be 2
    Then the stderr should contain "No outputter configured for formatter QAT::Formatter::Dashboard"

  @test#18 @user_story#30
  Scenario: Run dummy QAT project with dashboard formatter - check errors are published with MDC
    Given I set the environment variable to:
      | variable      | value                                              |
      | CUCUMBER_OPTS | --format QAT::Formatter::Dashboard --out Dashboard |
    When I run `rake mdc_error_tests`
    Then the exit status should be 1
    And I check the errors in the dashboard for this test:
      | logger                    | exception           | feature   | scenario                                         | tags                           | step      | status | outline_example          | outline_number | short_message                                            |
      | QAT::Formatter::Dashboard | Minitest::Assertion | mdc tests | MDC error                                        | @top_level_tag,@mdc,@mdc_error | And false | failed | nil                      | nil            | Caught Minitest::Assertion: Expected false to be truthy. |
      | QAT::Formatter::Dashboard | Minitest::Assertion | mdc tests | MDC error in outline                             | @top_level_tag,@mdc,@mdc_error | And false | failed | 1,temp,another           | 1              | Caught Minitest::Assertion: Expected false to be truthy. |
      | QAT::Formatter::Dashboard | Minitest::Assertion | mdc tests | MDC error in outline                             | @top_level_tag,@mdc,@mdc_error | And false | failed | 2,temp,parameter         | 2              | Caught Minitest::Assertion: Expected false to be truthy. |
      | QAT::Formatter::Dashboard | Minitest::Assertion | mdc tests | MDC with multiple outline tables - all enabled   | @top_level_tag,@mdc,@mdc_error | And false | failed | 1,temp,another           | 1              | Caught Minitest::Assertion: Expected false to be truthy. |
      | QAT::Formatter::Dashboard | Minitest::Assertion | mdc tests | MDC with multiple outline tables - all enabled   | @top_level_tag,@mdc,@mdc_error | And false | failed | 2,temp,parameter         | 2              | Caught Minitest::Assertion: Expected false to be truthy. |
      | QAT::Formatter::Dashboard | Minitest::Assertion | mdc tests | MDC with multiple outline tables - all enabled   | @top_level_tag,@mdc,@mdc_error | And false | failed | 1,still_temp,yet_another | 1              | Caught Minitest::Assertion: Expected false to be truthy. |
      | QAT::Formatter::Dashboard | Minitest::Assertion | mdc tests | MDC with multiple outline tables - all enabled   | @top_level_tag,@mdc,@mdc_error | And false | failed | 1,temp,yet_another       | 1              | Caught Minitest::Assertion: Expected false to be truthy. |
      | QAT::Formatter::Dashboard | Minitest::Assertion | mdc tests | MDC with multiple outline tables - some disabled | @top_level_tag,@mdc,@mdc_error | And false | failed | 1,temp,another           | 1              | Caught Minitest::Assertion: Expected false to be truthy. |
      | QAT::Formatter::Dashboard | Minitest::Assertion | mdc tests | MDC with multiple outline tables - some disabled | @top_level_tag,@mdc,@mdc_error | And false | failed | 2,temp,parameter         | 2              | Caught Minitest::Assertion: Expected false to be truthy. |
      | QAT::Formatter::Dashboard | Minitest::Assertion | mdc tests | MDC with multiple outline tables - some disabled | @top_level_tag,@mdc,@mdc_error | And false | failed | 1,temp,yet_another       | 1              | Caught Minitest::Assertion: Expected false to be truthy. |
