@core
Feature: core tests

  Scenario: Save variable in core
    When I save "bar" in core with key "foo"
    Then the value in core for "foo" is "bar"

  Scenario: Core is reset on hooks
    Then the value in core for "foo" is empty

  Scenario Outline: Core is reset on examples
    When I save "bar" in core with key "<key>"
    Then the value in core for "foo" is <value>
    Examples:
      | key   | value |
      | foo   | "bar" |
      | other | empty |

  Scenario: Save variable with persistence in core
    When I save "bar" in core with key "foo" with persistence
    Then the value in core for "foo" is "bar"

  Scenario: Core is reset on hooks but not persistant keys
    Then the value in core for "foo" is "bar"

  Scenario Outline: Core is reset on examples
    When I save "bar" in core with key "<key>" with persistence
    Then the value in core for "foo" is <value>
    Examples:
      | key   | value |
      | foo   | "bar" |
      | other | "bar" |

