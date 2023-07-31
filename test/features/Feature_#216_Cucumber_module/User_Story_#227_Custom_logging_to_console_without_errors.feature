@epic#198 @feature#216 @user_story#227 @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Feature #216: Cucumber module: User Story #227: Custom logging to console
  In order to have more information and better context for a test execution
  As a test developer
  I want to have a custom console formatter

  Scenario: No error when running simple cucumber
    Given I copy the directory named "../../resources/qat_project_no_before_test_case" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    And I run `mkdir -p public`
    And the exit status should be 0
    When I run `cucumber`
    Then the exit status should be 2