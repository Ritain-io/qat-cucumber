@epic#1 @feature#2 @user_story#3 @dummy_feature
Feature: some feature
  In order to do something
  As someone
  I want to specify scenarios

  Background: Some option precondition
    Given true

  @test#4 @dummy_test
  Scenario: true
    When true
    Then true

  @test#5 @dummy_test
  Scenario Outline: Many trues
    When <true>
    Then <true>
  Examples:
    | true |
    | true |
    | true |
    | true |
    | true |

  @test#6 @dummy_test
  Scenario: Some other trueness
    When true
    Then true

  @test#7 @dummy_test
  Scenario Outline: Regretion outline
    When <true>
    Then <true>
  Examples:
    | true |
    | true |
    | true |
    | true |
    | true |

  @test#8 @dummy_test
  Scenario: normal regretion
    When true
    Then true
