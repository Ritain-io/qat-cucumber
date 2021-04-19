@epic#198 @feature#216 @user_story#225 @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Feature#216: Cucumber module: User Story #225: Log test failures to Dashboard
  As a tester
  I want to have the test id information on the Dashboard
  In order to easily identify my failed test

  Background: Create QAT project
    Given I copy the directory named "../../resources/qat_project" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |

  Scenario: Send error data to Dashboard
    Given I set the environment variable to:
      | variable      | value                                              |
      | CUCUMBER_OPTS | --format QAT::Formatter::Dashboard --out Dashboard |
    When I run `rake mdc_with_ids_tests`
    Then the exit status should be 1
    And I check the errors in the dashboard for this test:
      | logger                    | exception           | feature                 | scenario                                                  | tags                                             | step      | outline_example          | outline_number | short_message                                            |
      | QAT::Formatter::Dashboard | Minitest::Assertion | mdc with test ids tests | MDC error with ids                                        | @top_level_tag,@mdc_with_ids,@mdc_with_ids_error | And false | nil                      | nil            | Caught Minitest::Assertion: Expected false to be truthy. |
      | QAT::Formatter::Dashboard | Minitest::Assertion | mdc with test ids tests | MDC error in outline with ids                             | @top_level_tag,@mdc_with_ids,@mdc_with_ids_error | And false | 1,temp,another           | 1              | Caught Minitest::Assertion: Expected false to be truthy. |
      | QAT::Formatter::Dashboard | Minitest::Assertion | mdc with test ids tests | MDC error in outline with ids                             | @top_level_tag,@mdc_with_ids,@mdc_with_ids_error | And false | 2,temp,parameter         | 2              | Caught Minitest::Assertion: Expected false to be truthy. |
      | QAT::Formatter::Dashboard | Minitest::Assertion | mdc with test ids tests | MDC with multiple outline tables with ids - all enabled   | @top_level_tag,@mdc_with_ids,@mdc_with_ids_error | And false | 1,temp,another           | 1              | Caught Minitest::Assertion: Expected false to be truthy. |
      | QAT::Formatter::Dashboard | Minitest::Assertion | mdc with test ids tests | MDC with multiple outline tables with ids - all enabled   | @top_level_tag,@mdc_with_ids,@mdc_with_ids_error | And false | 2,temp,parameter         | 2              | Caught Minitest::Assertion: Expected false to be truthy. |
      | QAT::Formatter::Dashboard | Minitest::Assertion | mdc with test ids tests | MDC with multiple outline tables with ids - all enabled   | @top_level_tag,@mdc_with_ids,@mdc_with_ids_error | And false | 1,still_temp,yet_another | 1              | Caught Minitest::Assertion: Expected false to be truthy. |
      | QAT::Formatter::Dashboard | Minitest::Assertion | mdc with test ids tests | MDC with multiple outline tables with ids - all enabled   | @top_level_tag,@mdc_with_ids,@mdc_with_ids_error | And false | 1,temp,yet_another       | 1              | Caught Minitest::Assertion: Expected false to be truthy. |
      | QAT::Formatter::Dashboard | Minitest::Assertion | mdc with test ids tests | MDC with multiple outline tables with ids - some disabled | @top_level_tag,@mdc_with_ids,@mdc_with_ids_error | And false | 1,temp,another           | 1              | Caught Minitest::Assertion: Expected false to be truthy. |
      | QAT::Formatter::Dashboard | Minitest::Assertion | mdc with test ids tests | MDC with multiple outline tables with ids - some disabled | @top_level_tag,@mdc_with_ids,@mdc_with_ids_error | And false | 2,temp,parameter         | 2              | Caught Minitest::Assertion: Expected false to be truthy. |
      | QAT::Formatter::Dashboard | Minitest::Assertion | mdc with test ids tests | MDC with multiple outline tables with ids - some disabled | @top_level_tag,@mdc_with_ids,@mdc_with_ids_error | And false | 4,temp,yet_another       | 1              | Caught Minitest::Assertion: Expected false to be truthy. |


  Scenario: Run dummy QAT project with console formatter - check MDC is set
    Given I set the environment variable to:
      | variable      | value                            |
      | CUCUMBER_OPTS | --format QAT::Formatter::Console |
    When I run `rake mdc_with_ids_tests`
    And the exit status should be 1