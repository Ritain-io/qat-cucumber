@us#3 @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Complete test id information report
  As a tester,
  In order to see if there any duplicate test ids,
  I want to have the test id information in the test id report
  @test#32312
  Scenario: Report for test project with duplicate test ids
    Given I copy the directory named "../../resources/qat_project_access_current_test_data" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:test:run`
    And the exit status should be 0