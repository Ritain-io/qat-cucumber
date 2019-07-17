@epic#198 @feature#220 @user_story#233 @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Feature #220: Rake tasks; User Story #233: Run a complete feature of test scenarios
  In order to run all tests from a feature path in my project
  As a test developer
  I want to execute a rake task providing the feature path

  @test#46
  Scenario: Run a feature in a project with mixed results
    Given I copy the directory named "../../resources/qat_project_with_tasks_tagged" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:test:feature[example1]`
    Then the output should match:
    """
    2 scenarios \(1 failed, 1 passed\)
    8 steps \(1 failed, 7 passed\)
    \d+m\d+\.\d+s
    """
    And the exit status should be 1

  @test#47
  Scenario: Run a feature in a sub-folder in a project with mixed results
    Given I copy the directory named "../../resources/qat_project_with_tasks_tagged" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:test:feature[some_folder/example2]`
    Then the output should match:
    """
    3 scenarios \(2 pending, 1 passed\)
    9 steps \(2 undefined, 2 pending, 5 passed\)
    \d+m\d+\.\d+s
    """
    And the exit status should be 0

  @test#48
  Scenario: Run a feature with only successful results
    Given I copy the directory named "../../resources/qat_project_all_successful" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:test:feature[example1]`
    Then the output should match:
    """
    2 scenarios \(2 passed\)
    8 steps \(8 passed\)
    \d+m\d+\.\d+s
    """
    And the exit status should be 0

  @test#49
  Scenario: Run a feature that does not exists
    Given I copy the directory named "../../resources/qat_project_without_features" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:test:feature[example1]`
    Then the output should match:
    """
    0 scenarios
    0 steps
    \d+m\d+\.\d+s
    """
    And the exit status should be 0

  @test#50
  Scenario: Run task without a feature
    Given I copy the directory named "../../resources/qat_project_all_successful" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:test:feature[]`
    Then the output should match:
    """
    rake aborted!
    ArgumentError: A feature is needed to execute the task!
    """
    And the exit status should be 1