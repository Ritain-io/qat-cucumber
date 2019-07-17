@tagged_feature
Feature: Tagged feature

  Background: a background
    Given some pre-settings

  @test#4
  Scenario: example 1 scenario 1
    Given some conditions
    When some actions are made
    Then a result is achieved

  @test#2
  Scenario: example 1 scenario 2
    Given some conditions
    When some actions are made
    Then a result is achieved
