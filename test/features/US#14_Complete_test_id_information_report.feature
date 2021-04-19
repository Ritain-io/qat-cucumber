@us#14 @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Complete test id information report
  As a tester,
  In order to see if there any duplicate test ids,
  I want to have the test id information in the test id report
  Scenario: Report for test project with duplicate test ids
    Given I copy the directory named "../../resources/qat_project_duplicate_test_ids" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:tags:validate_test_ids`
    Then the output should contain:
    """
    ------------------------------------
    Duplicate test ids found!
    ------------------------------------
    TEST ID 2:
    Scenario: example 1 scenario 2 - features/example1.feature:14
    Scenario: example 2 scenario 1 - features/example2.feature:4
    Scenario: example 3 scenario 1 - features/example3.feature:4
    """
    And a file named "public/test_ids.json" should contain:
    """
    {
      "max": 4,
      "untagged": {
      },
      "mapping": {
        "1": {
          "name": "example 3 scenario 2",
          "path": "features/example3.feature:10"
        },
        "2": {
          "name": "example 1 scenario 2",
          "path": "features/example1.feature:14"
        },
        "3": {
          "name": "example 2 scenario 2",
          "path": "features/example2.feature:10"
        },
        "4": {
          "name": "example 1 scenario 1",
          "path": "features/example1.feature:8"
        }
      },
      "duplicate": {
        "2": [
          {
            "name": "example 1 scenario 2",
            "path": "features/example1.feature:14"
          },
          {
            "name": "example 2 scenario 1",
            "path": "features/example2.feature:4"
          },
          {
            "name": "example 3 scenario 1",
            "path": "features/example3.feature:4"
          }
        ]
      }
    }
    """
    And the exit status should be 1