@epic#198 @feature#220 @user_story#235 @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Feature #220: Rake tasks; User Story #235: Automatic generation of test ids for test scenarios
  In order to give all test scenarios a unique identifier
  As a test developer
  I want to execute a rake task to generate test ids

  @test#58
  Scenario: Get a report on test ids in test scenarios in a project without test ids
    Given I copy the directory named "../../resources/qat_project_with_tasks_tagged" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:tags:report_test_ids`
    Then a file named "./public/test_ids.json" should contain:
    """
    {
     "max": 0,
     "untagged": {
      "this scenario has tags": "features/example1.feature:8",
      "this scenario has no tags": "features/example1.feature:13",
      "this scenario also has tags": "features/some_folder/example2.feature:5",
      "this scenario outline has tags": "features/some_folder/example2.feature:11"
     },
     "mapping": {
     },
     "duplicate": {
     }
    }
    """
    And the exit status should be 0

  @test#59
  Scenario: Give test ids to test scenarios in a project without test ids
    Given I copy the directory named "../../resources/qat_project_with_tasks_tagged" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:tags:test_ids`
    Then the output should match:
    """
    ^Disabling profiles...
    Giving test ids to scenarios:
    {
     "features/example1.feature": \[  8,  13\],
     "features/some_folder/example2.feature": \[  5,  11\]
    }
    """
    And a file named "./public/test_ids.json" should contain:
    """
    {
     "max": 0,
     "untagged": {
      "this scenario has tags": "features/example1.feature:8",
      "this scenario has no tags": "features/example1.feature:13",
      "this scenario also has tags": "features/some_folder/example2.feature:5",
      "this scenario outline has tags": "features/some_folder/example2.feature:11"
     },
     "mapping": {
     },
     "duplicate": {
     }
    }
    """
    And the exit status should be 0

  @test#60
  Scenario: Get a report on test ids of test scenarios after giving test ids in a project without test ids
    Given I copy the directory named "../../resources/qat_project_with_tasks_tagged" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    And I run `rake qat:tags:test_ids`
    And the output should match:
    """
    ^Disabling profiles...
    Giving test ids to scenarios:
    {
     "features/example1.feature": \[  8,  13\],
     "features/some_folder/example2.feature": \[  5,  11\]
    }
    """
    When I run `rake qat:tags:report_test_ids`
    Then a file named "./public/test_ids.json" should contain:
    """
    {
     "max": 4,
     "untagged": {
     },
     "mapping": {
      "1": {
       "name": "this scenario has tags",
       "path": "features/example1.feature:8"
      },
      "2": {
       "name": "this scenario has no tags",
       "path": "features/example1.feature:14"
      },
      "3": {
       "name": "this scenario also has tags",
       "path": "features/some_folder/example2.feature:5"
      },
      "4": {
       "name": "this scenario outline has tags",
       "path": "features/some_folder/example2.feature:11"
      }
     },
     "duplicate": {
     }
    }
    """
    And the exit status should be 0

  @test#61
  Scenario: Get a report on test ids in test scenarios in a project with existing test ids
    Given I copy the directory named "../../resources/qat_project_max_test_id" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:tags:report_test_ids`
    Then a file named "./public/test_ids.json" should contain:
    """
    {
     "max": 23,
     "untagged": {
      "this scenario has tags": "features/example1.feature:8",
      "this scenario has no tags": "features/example1.feature:13",
      "this scenario outline has no tags": "features/example2.feature:9"
     },
     "mapping": {
      "23": {
       "name": "this scenario also has no tags",
       "path": "features/example2.feature:4"
      }
     },
     "duplicate": {
     }
    }
    """
    And the exit status should be 0

  @test#62
  Scenario: Give test ids to test scenarios in a project with existing test ids
    Given I copy the directory named "../../resources/qat_project_max_test_id" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:tags:test_ids`
    Then the output should match:
    """
    ^Disabling profiles...
    Giving test ids to scenarios:
    {
     "features/example1.feature": \[  8,  13\],
     "features/example2.feature": \[  9\]
    }
    """
    And a file named "./public/test_ids.json" should contain:
    """
    {
     "max": 23,
     "untagged": {
      "this scenario has tags": "features/example1.feature:8",
      "this scenario has no tags": "features/example1.feature:13",
      "this scenario outline has no tags": "features/example2.feature:9"
     },
     "mapping": {
      "23": {
       "name": "this scenario also has no tags",
       "path": "features/example2.feature:4"
      }
     },
     "duplicate": {
     }
    }
    """
    And the exit status should be 0

  @test#63
  Scenario: Get a report on test ids of test scenarios after giving test ids in a project already with test ids
    Given I copy the directory named "../../resources/qat_project_max_test_id" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    And I run `rake qat:tags:test_ids`
    And the output should match:
    """
    ^Disabling profiles...
    Giving test ids to scenarios:
    {
     "features/example1.feature": \[  8,  13\],
     "features/example2.feature": \[  9\]
    }
    """
    When I run `rake qat:tags:report_test_ids`
    Then a file named "./public/test_ids.json" should contain:
    """
    {
     "max": 26,
     "untagged": {
     },
     "mapping": {
      "23": {
       "name": "this scenario also has no tags",
       "path": "features/example2.feature:4"
      },
      "24": {
       "name": "this scenario has tags",
       "path": "features/example1.feature:8"
      },
      "25": {
       "name": "this scenario has no tags",
       "path": "features/example1.feature:14"
      },
      "26": {
       "name": "this scenario outline has no tags",
       "path": "features/example2.feature:10"
      }
     },
     "duplicate": {
     }
    }
    """
    And the exit status should be 0

  @test#64
  Scenario: Get a report on test ids in test scenarios in a project without features
    Given I copy the directory named "../../resources/qat_project_without_features" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:tags:report_test_ids`
    Then a file named "./public/test_ids.json" should contain:
    """
    {
     "max": 0,
     "untagged": {
     },
     "mapping": {
     },
     "duplicate": {
     }
    }
    """
    And the exit status should be 0

  @test#65
  Scenario: Give test ids to test scenarios in a project without features
    Given I copy the directory named "../../resources/qat_project_without_features" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:tags:test_ids`
    Then the output should match:
    """
    ^Disabling profiles...
    There are no scenarios without test id.
    """
    And a file named "public/test_ids.json" should contain:
    """
    {
     "max": 0,
     "untagged": {
     },
     "mapping": {
     },
     "duplicate": {
     }
    }
    """
    And the exit status should be 0

  Scenario: Get a report on test ids in test scenarios in a project without test ids and no scenarios with steps
    Given I copy the directory named "../../resources/qat_project_with_tasks_empty_scenario" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:tags:report_test_ids`
    Then a file named "./public/test_ids.json" should contain:
    """
    {
     "max": 0,
     "untagged": {
     },
     "mapping": {
     },
     "duplicate": {
     }
    }
    """
    And the exit status should be 0

  Scenario: Give test ids to test scenarios in a project without test ids and no scenarios with steps
    Given I copy the directory named "../../resources/qat_project_with_tasks_empty_scenario" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:tags:test_ids`
    Then the output should match:
    """
    ^Disabling profiles...
    There are no scenarios without test id.
    """
    And a file named "./public/test_ids.json" should contain:
    """
    {
     "max": 0,
     "untagged": {
     },
     "mapping": {
     },
     "duplicate": {
     }
    }
    """
    And the exit status should be 0