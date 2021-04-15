@epic#198 @feature#220 @user_story#239 @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Feature #220: Rake tasks; User Story #239: List all scenarios without tags
  In order to have all scenarios tagged
  As a test developer
  I want to execute a rake task to list all untagged scenarios

  @test#76
  Scenario: List all scenarios within a project with untagged scenarios
    Given I copy the directory named "../../resources/qat_project_with_tasks" to "project"
    And I cd to "project"
    When I run `rake qat:list:untagged`
    Then the output should contain:
    """
    {
      "untagged": {
        "this scenario also has no tags": "features/example2.feature:3",
        "this scenario outline has no tags": "features/example2.feature:8"
      },
    """
    And the exit status should be 0

  @test#77
  Scenario: List all scenarios within a project without untagged scenarios
    Given I copy the directory named "../../resources/qat_project_with_tasks_tagged" to "project"
    And I cd to "project"
    When I run `rake qat:list:untagged`
    Then the output should contain:
    """
    {
      "untagged": {
      },
    """
    And the exit status should be 0

  @test#78
  Scenario: List all scenarios within a project without features
    Given I copy the directory named "../../resources/qat_project_without_features" to "project"
    And I cd to "project"
    When I run `rake qat:list:untagged`
    Then the output should match:
    """
    {
      "untagged": {
      },
    """
    And the exit status should be 0
