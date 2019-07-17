@hooks
Feature: hooks tests

  @my_tag
  Scenario: Scenario tags are saved
    Then the value in core for "scenario_tags" is "["@hooks", "@my_tag"]"

  Scenario: Scenario tags are reset for each scenario
    Then the value in core for "scenario_tags" is "["@hooks"]"

  Scenario: Stop time
    Given I freeze the clock at "2030-12-25 12:34:56 +0000"

  Scenario: Time start is as expected
    Then the value in core for "test_start_timestamp" is "2030-12-25 12:34:56 +0000"
    And I reset the clock

  Scenario: Save a file in tmp folder
    When I save a "dummy.txt" file in tmp folder
    Then there is a "dummy.txt" file in tmp folder

  Scenario: Tmp folder is reset
    Then there isn't a "dummy.txt" file in tmp folder

