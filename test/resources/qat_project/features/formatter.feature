@formatter
Feature: formatter tests

  Background: background
    Given true

  Scenario: true
    When true
    Then true

  Scenario Outline: Many trues
    When <true>
    Then <true>
    And <true>

  Examples:
    | true |
    | true |
    | true |

  Scenario: false
    When false

  Scenario Outline: Many falses
    Then <false>

    Examples:
      | false |
      | false |
      | false |

  Scenario: pending
    When pending

  Scenario Outline: Many pending
    Then <pending>

    Examples:
      | pending |
      | pending |
      | pending |

