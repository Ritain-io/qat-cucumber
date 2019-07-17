@example
Feature: tests

  @tasks @qat
  Scenario: true
    When true
    Then true

  @tasks @qat
  Scenario Outline: Many trues
    When <true>
    Then <true>

  Examples:
    | true |
    | true |
    | true |

