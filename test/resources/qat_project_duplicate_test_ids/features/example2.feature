Feature: Untagged feature

  @test#2
  Scenario: example 2 scenario 1
    Given some conditions
    When some actions are made
    Then a result is achieved

  @test#3
  Scenario Outline: example 2 scenario 2
    Given some conditions
    When action <action> is made
    Then <result> is achieved

    Examples: the examples
      | action  | result  |
      | action1 | result1 |
      | action2 | result2 |