@us#3 @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Complete test id information report
  As a tester,
  In order to see if there any duplicate test ids,
  I want to have the test id information in the test id report

  Scenario: Report for embedding Video file on Html report
    Given I copy the directory named "../../resources/qat_project" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value                        |
      | CUCUMBER_FORMAT |                              |
      | CUCUMBER_OPTS   | --format junit --out public/ |
    When I run `rake assertions_tests`
    Then the exit status should be 0
    And Then the XML report for JUnit and XUnit contains a time tag with 3 decimal numbers
