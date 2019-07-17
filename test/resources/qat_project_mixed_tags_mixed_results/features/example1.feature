@user_story#603
Feature: Tagged feature

  Background: a background
    Given some pre-settings

  @test#1
  Scenario: scenario 1
    Given some conditions
    When some actions are made
    Then a result is achieved

  @test#2 @user_story#6033
  Scenario: scenario 2
    Given some failed conditions
    When some actions are made
    Then a result is achieved

  @test#3 @user_story#6032
  Scenario Outline: scenario 3
    Given some failed conditions
    When some "<action>" action made
    Then "<result>" result is achieved

    Examples:
      | action | result |
      | good   | good   |
      | good   | good   |


  @test#4
  Scenario: scenario 4
    Given some failed conditions
    When some actions are made
    Then a result is achieved