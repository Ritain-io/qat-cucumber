@tagged_feature
Feature: As a test developer, I want to access current test data, In order to better use the current test context


  @test#4
  Scenario: verify test_id during execution of scenario
    Then The test id should be "test_4"
    And the test run id is correctly defined
    And the evidence prefix is correctly defined

#  @test#5
#  Scenario Outline: verify test_id during execution of scenario outline
#    Then The test id should be "<test_id>"
#    And the test run id is correctly defined
#    And the evidence prefix is correctly defined
#
#    Examples:
#    |test_id |
#    |test_5_1|
#    |test_5_2|

