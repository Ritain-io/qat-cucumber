@epic#198 @feature#220 @user_story#234 @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Feature #220: Rake tasks; User Story #234: Run all test scenarios containing given tags
  In order to run all tests containing at least one tag of a group of tags
  As a test developer
  I want to execute a rake task providing the group of tags

  @test#51
  Scenario: Run a complete feature using a feature tagged with mixed results
    Given I copy the directory named "../../resources/qat_project_with_tasks_tagged" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:test:tags[@tagged_feature]`
    Then the output should match:
    """
    2 scenarios \(1 failed, 1 passed\)
    8 steps \(1 failed, 7 passed\)
    \d+m\d+\.\d+s
    """
    And the exit status should be 1

  @test#52
  Scenario: Run feature tests using a shared tag
    Given I copy the directory named "../../resources/qat_project_with_tasks_tagged" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:test:tags[@common_tag]`
    Then the output should match:
    """
    3 scenarios \(2 pending, 1 passed\)
    9 steps \(2 undefined, 2 pending, 5 passed\)
    \d+m\d+\.\d+s
    """
    And the exit status should be 0

  @test#53
  Scenario: Run test scenarios from multiples features with common tag
    Given I copy the directory named "../../resources/qat_project_with_tasks_tagged" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:test:tags[@tagged_scenario]`
    Then the output should match:
    """
    2 scenarios \(2 passed\)
    7 steps \(7 passed\)
    \d+m\d+\.\d+s
    """
    And the exit status should be 0

  @test#54
  Scenario: Run test with a tag that does not exists
    Given I copy the directory named "../../resources/qat_project_all_successful" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:test:tags[@thistagdoesnotexistanywhere]`
    Then the output should match:
    """
    0 scenarios
    0 steps
    \d+m\d+\.\d+s
    """
    And the exit status should be 0

  @test#55
  Scenario: Run tests with tags in a project without features
    Given I copy the directory named "../../resources/qat_project_without_features" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:test:tags[@tagged_scenario]`
    Then the output should match:
    """
    0 scenarios
    0 steps
    \d+m\d+\.\d+s
    """
    And the exit status should be 0

  @test#56
  Scenario: Run task without a tag
    Given I copy the directory named "../../resources/qat_project_all_successful" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:test:tags[]`
    Then the output should match:
    """
    rake aborted!
    ArgumentError: A tag is needed to execute the task!
    """
    And the exit status should be 1

  @test#57
  Scenario: Run task with a tags list
    Given I copy the directory named "../../resources/qat_project_all_successful" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:test:feature[@tagged_feature,@previous_untagged_feature]`
    Then the output should match:
    """
    5 scenarios \(5 passed\)
    17 steps \(17 passed\)
    \d+m\d+\.\d+s
    """
    And the exit status should be 0