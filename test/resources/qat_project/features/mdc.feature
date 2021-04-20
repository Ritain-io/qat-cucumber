@top_level_tag
Feature: mdc tests

  Background: just for testing
    Given the MDC has the values
      | feature   | step                         |
      | mdc tests | Given the MDC has the values |

  @mdc @my_tag @mdc_success
  Scenario: MDC tags check
    Then the MDC has the values
      | feature   | scenario       | step                        | tags                                     |
      | mdc tests | MDC tags check | Then the MDC has the values | @top_level_tag,@mdc,@my_tag,@mdc_success |
    And the MDC has the values
      | feature   | scenario       | step                       | tags                                     |
      | mdc tests | MDC tags check | And the MDC has the values | @top_level_tag,@mdc,@my_tag,@mdc_success |

  @mdc @mdc_success
  Scenario Outline: MDC with outline
    When the MDC has the values
      | feature   | scenario         | step                        | tags                             | outline_number | outline_example         |
      | mdc tests | MDC with outline | When the MDC has the values | @top_level_tag,@mdc,@mdc_success | <num>          | <num>,<param1>,<param2> |
    Then the MDC has the values
      | feature   | scenario         | step                        | tags                             | outline_number | outline_example         |
      | mdc tests | MDC with outline | Then the MDC has the values | @top_level_tag,@mdc,@mdc_success | <num>          | <num>,<param1>,<param2> |
    Examples:
      | num | param1 | param2    |
      | 1   | temp   | another   |
      | 2   | temp   | parameter |

  @mdc @mdc_success
  Scenario Outline: MDC with multiple outline tables - all enabled
    When the MDC has the values
      | feature   | scenario                                       | step                        | tags                             | outline_number | outline_example         |
      | mdc tests | MDC with multiple outline tables - all enabled | When the MDC has the values | @top_level_tag,@mdc,@mdc_success | <num>          | <num>,<param1>,<param2> |
    Then the MDC has the values
      | feature   | scenario                                       | step                        | tags                             | outline_number | outline_example         |
      | mdc tests | MDC with multiple outline tables - all enabled | Then the MDC has the values | @top_level_tag,@mdc,@mdc_success | <num>          | <num>,<param1>,<param2> |
    Examples: First table
      | num | param1 | param2    |
      | 1   | temp   | another   |
      | 2   | temp   | parameter |
    Examples: Second table
      | num | param1     | param2      |
      | 1   | still_temp | yet_another |
    Examples: Third table
      | num | param1 | param2      |
      | 1   | temp   | yet_another |

  Scenario Outline: MDC with multiple outline tables - some disabled
    When the MDC has the values
      | feature   | scenario                                         | step                        | tags                             | outline_number | outline_example         |
      | mdc tests | MDC with multiple outline tables - some disabled | When the MDC has the values | @top_level_tag,@mdc,@mdc_success | <num>          | <num>,<param1>,<param2> |
    Then the MDC has the values
      | feature   | scenario                                         | step                        | tags                             | outline_number | outline_example         |
      | mdc tests | MDC with multiple outline tables - some disabled | Then the MDC has the values | @top_level_tag,@mdc,@mdc_success | <num>          | <num>,<param1>,<param2> |
  @mdc @mdc_success
    Examples: Enabled table
      | num | param1 | param2    |
      | 1   | temp   | another   |
      | 2   | temp   | parameter |
    Examples: Disabled table
      | num          | param1       | param2       |
      | will_not_run | will_not_run | will_not_run |
  @mdc @mdc_success
    Examples: Another enabled table
      | num | param1 | param2      |
      | 1   | temp   | yet_another |

  @mdc @mdc_error
  Scenario: MDC error
    Then the MDC has the values
      | feature   | scenario  | step                        | tags                           |
      | mdc tests | MDC error | Then the MDC has the values | @top_level_tag,@mdc,@mdc_error |
    And the MDC has the values
      | feature   | scenario  | step                       | tags                           |
      | mdc tests | MDC error | And the MDC has the values | @top_level_tag,@mdc,@mdc_error |
    And false

  @mdc @mdc_error
  Scenario Outline: MDC error in outline
    When the MDC has the values
      | feature   | scenario             | step                        | tags                           | outline_number | outline_example         |
      | mdc tests | MDC error in outline | When the MDC has the values | @top_level_tag,@mdc,@mdc_error | <num>          | <num>,<param1>,<param2> |
    Then the MDC has the values
      | feature   | scenario             | step                        | tags                           | outline_number | outline_example         |
      | mdc tests | MDC error in outline | Then the MDC has the values | @top_level_tag,@mdc,@mdc_error | <num>          | <num>,<param1>,<param2> |
    And false
    Examples:
      | num | param1 | param2    |
      | 1   | temp   | another   |
      | 2   | temp   | parameter |

  @mdc @mdc_error
  Scenario Outline: MDC with multiple outline tables - all enabled
    When the MDC has the values
      | feature   | scenario                                       | step                        | tags                           | outline_number | outline_example         |
      | mdc tests | MDC with multiple outline tables - all enabled | When the MDC has the values | @top_level_tag,@mdc,@mdc_error | <num>          | <num>,<param1>,<param2> |
    Then the MDC has the values
      | feature   | scenario                                       | step                        | tags                           | outline_number | outline_example         |
      | mdc tests | MDC with multiple outline tables - all enabled | Then the MDC has the values | @top_level_tag,@mdc,@mdc_error | <num>          | <num>,<param1>,<param2> |
    And false
    Examples: First table
      | num | param1 | param2    |
      | 1   | temp   | another   |
      | 2   | temp   | parameter |
    Examples: Second table
      | num | param1     | param2      |
      | 1   | still_temp | yet_another |
    Examples: Third table
      | num | param1 | param2      |
      | 1   | temp   | yet_another |


  Scenario Outline: MDC with multiple outline tables - some disabled
    When the MDC has the values
      | feature   | scenario                                         | step                        | tags                           | outline_number | outline_example         |
      | mdc tests | MDC with multiple outline tables - some disabled | When the MDC has the values | @top_level_tag,@mdc,@mdc_error | <num>          | <num>,<param1>,<param2> |
    Then the MDC has the values
      | feature   | scenario                                         | step                        | tags                           | outline_number | outline_example         |
      | mdc tests | MDC with multiple outline tables - some disabled | Then the MDC has the values | @top_level_tag,@mdc,@mdc_error | <num>          | <num>,<param1>,<param2> |
    And false
  @mdc @mdc_error
    Examples: Enabled table
      | num | param1 | param2    |
      | 1   | temp   | another   |
      | 2   | temp   | parameter |
    Examples: Disabled table
      | num          | param1       | param2       |
      | will_not_run | will_not_run | will_not_run |
  @mdc @mdc_error
    Examples: Another enabled table
      | num | param1 | param2      |
      | 1   | temp   | yet_another |
