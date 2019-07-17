@us#3 @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Complete test id information report
  As a tester,
  In order to see if there any duplicate test ids,
  I want to have the test id information in the test id report

  Scenario: Report for embedding Video file on Html report
    Given I copy the directory named "../../resources/qat_project_test_video_embed" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `rake qat:test:run`
    And Then the HTML report contains a video tag linked to the given file
    And The video can be downloaded
    And the exit status should be 0
