@epic#198 @feature#220 @user_story#237 @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Feature #220: Rake tasks; User Story #237: List scenarios by tag
  In order to know the test list for a given requirement
  As a tester
  I want to execute a rake task with the requirement tag as input

  Background:
    Given I copy the directory named "../../resources/qat_project_with_tasks" to "project"
    And I cd to "project"

  @test#69
  Scenario: List all scenarios with an existing tag
    When I run `rake qat:list:by_tag[@qat]`
    Then the output should match:
    """
    ^Disabling profiles...
    true: features/tests.feature:5
    Many trues: features/tests.feature:10\s*$
    """
    And the exit status should be 0

  @test#70
  Scenario: List all scenarios with an non existing tag
    When I run `rake qat:list:by_tag[@thisisrubbish]`
    Then the output should match:
    """
    ^Disabling profiles...\s*$
    """
    And the exit status should be 0

  @test#71
  Scenario: List all scenarios with an invalid tag
    When I run `rake qat:list:by_tag[thisisnotavalidtag]`
    Then the output should match:
    """
    ^rake aborted!
    ArgumentError: Tag 'thisisnotavalidtag' is invalid!\s*$
    """
    And the exit status should be 1

  @test#72
  Scenario: Executing rake without a tag
    When I run `rake qat:list:by_tag`
    Then the output should match:
    """
    ^rake aborted!
    ArgumentError: A tag is needed to execute the task!\s*$
    """
    And the exit status should be 1
