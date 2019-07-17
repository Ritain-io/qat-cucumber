@epic#198 @feature#220 @user_story#238 @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Feature #220: Rake tasks; User Story #238: List all duplicated names for scenarios
  In order to identify repeated scenario names
  As a test developer
  I want to execute a rake task to list all of those scenarios

  @test#73
  Scenario: List all duplicate scenarios names in a project without duplicate scenario names
    Given I copy the directory named "../../resources/qat_project_with_tasks_tagged" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:list:dup_names`
    Then the output should match:
    """
    ^Disabling profiles...\s*$
    """
    And I run `ruby -e "puts File.read './scenarios.json'"`
    Then the output should match:
    """
    \s*},
     "repeated": {
     }
    }\s*$
    """
    And the exit status should be 0

  @test#74
  Scenario: List all duplicate scenarios names in a project with duplicate scenario names
    Given I copy the directory named "../../resources/qat_project_all_successful" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:list:dup_names`
    Then the output should match:
    """
    ^Disabling profiles...\s*$
    """
    And I run `ruby -e "puts File.read './scenarios.json'"`
    Then the output should match:
    """
    \s*},
     "repeated": {
      "this scenario has tags": \[\s*"features/example1.feature:13",\s*"features/example2.feature:4"\]
     }
    }\s*$
    """
    And the exit status should be 0

  @test#75
  Scenario: List all duplicate scenarios names in a project without features
    Given I copy the directory named "../../resources/qat_project_without_features" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:list:dup_names`
    Then the output should match:
    """
    ^Disabling profiles...\s*$
    """
    And I run `ruby -e "puts File.read './scenarios.json'"`
    Then the output should match:
    """
    \s*},
     "repeated": {
     }
    }\s*$
    """
    And the exit status should be 0

  @test#80
  Scenario: List all duplicate scenarios names in a specific path of the project
    Given I copy the directory named "../../resources/qat_project_all_successful" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:list:dup_names[features/example2.feature]`
    Then the output should match:
    """
    ^Disabling profiles...\s*$
    """
    And I run `ruby -e "puts File.read './scenarios.json'"`
    Then the output should match:
    """
    \s*},
     "repeated": {
     }
    }\s*$
    """
    And the exit status should be 0