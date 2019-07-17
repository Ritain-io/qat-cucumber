@epic#198 @feature#220 @user_story#232 @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Feature #220: Rake tasks; User Story #232: Run all test scenarios
  In order to run all tests in my project
  As a test developer
  I want to execute a rake task

  @test#43
  Scenario: Run all test scenarios in a project with mixed results
    Given I copy the directory named "../../resources/qat_project_with_tasks_tagged" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:test:run`
    Then the output should match:
    """
    5 scenarios \(1 failed, 2 pending, 2 passed\)
    17 steps \(1 failed, 2 undefined, 2 pending, 12 passed\)
    \d+m\d+\.\d+s
    """
    And the exit status should be 1

  @test#44
  Scenario: Run all test scenarios in a project with only successful results
    Given I copy the directory named "../../resources/qat_project_all_successful" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:test:run`
    Then the output should match:
    """
    5 scenarios \(5 passed\)
    17 steps \(17 passed\)
    \d+m\d+\.\d+s
    """
    And the exit status should be 0

  @test#45
  Scenario: Run all test scenarios in a project without features
    Given I copy the directory named "../../resources/qat_project_without_features" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:test:run`
    Then the output should match:
    """
    0 scenarios
    0 steps
    \d+m\d+\.\d+s
    """
    And the exit status should be 0