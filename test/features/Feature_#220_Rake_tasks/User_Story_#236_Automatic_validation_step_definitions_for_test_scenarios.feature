@epic#198 @feature#220 @user_story#236 @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Feature #220: Rake tasks; User Story #236: Automatic validation step definitions for test scenarios
  In order to validate my test specification completeness
  As a test developer
  I want to execute a rake task to validate if all steps are defined

  @test#66
  Scenario: Run step validation in a project with undefined steps
    Given I copy the directory named "../../resources/qat_project_with_tasks" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:steps:validation`
    Then the output should match:
    """
    8 scenarios \(3 skipped, 5 undefined\)
    23 steps \(6 skipped, 17 undefined\)

    You can implement step definitions for undefined steps with these snippets:
    """
    And the exit status should be 0

  @test#67
  Scenario: Run step validation in a project without undefined steps
    Given I copy the directory named "../../resources/qat_project_all_successful" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:steps:validation`
    Then the output should match:
    """
    5 scenarios \(5 skipped\)
    17 steps \(17 skipped\)
    """
    And the exit status should be 0

  @test#68
  Scenario: Run step validation in a project without features
    Given I copy the directory named "../../resources/qat_project_without_features" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:steps:validation`
    Then the output should match:
    """
    0 scenarios
    0 steps
    """
    And the exit status should be 0