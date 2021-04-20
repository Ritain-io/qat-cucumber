@top_level_tag
Feature: mdc with test ids tests

  Background: just for testing
    Given the MDC has the values
      | feature                 | step                         |
      | mdc with test ids tests | Given the MDC has the values |

  @mdc_with_ids @my_tag @mdc_with_ids_success @test#10000
  Scenario: MDC tags check with ids
    Then the MDC has the values
      | feature                 | scenario                | step                        | tags                                                       | test_id    |
      | mdc with test ids tests | MDC tags check with ids | Then the MDC has the values | @top_level_tag,@mdc_with_ids,@my_tag,@mdc_with_ids_success | test_10000 |
    And the MDC has the values
      | feature                 | scenario                | step                       | tags                                                       | test_id    |
      | mdc with test ids tests | MDC tags check with ids | And the MDC has the values | @top_level_tag,@mdc_with_ids,@my_tag,@mdc_with_ids_success | test_10000 |

  @mdc_with_ids @mdc_with_ids_success @test#10001
  Scenario Outline: MDC with outline with ids
    When the MDC has the values
      | feature                 | scenario                  | step                        | tags                                               | outline_number | outline_example         | test_id          |
      | mdc with test ids tests | MDC with outline with ids | When the MDC has the values | @top_level_tag,@mdc_with_ids,@mdc_with_ids_success | <num>          | <num>,<param1>,<param2> | test_10001.<num> |
    Then the MDC has the values
      | feature                 | scenario                  | step                        | tags                                               | outline_number | outline_example         | test_id          |
      | mdc with test ids tests | MDC with outline with ids | Then the MDC has the values | @top_level_tag,@mdc_with_ids,@mdc_with_ids_success | <num>          | <num>,<param1>,<param2> | test_10001.<num> |
    Examples:
      | num | param1 | param2    |
      | 1   | temp   | another   |
      | 2   | temp   | parameter |

  @mdc_with_ids @mdc_with_ids_success @test#10002
  Scenario Outline: MDC with multiple outline tables with ids - all enabled
    When the MDC has the values
      | feature                 | scenario                                                | step                        | tags                                               | outline_number | outline_example         | test_id          |
      | mdc with test ids tests | MDC with multiple outline tables with ids - all enabled | When the MDC has the values | @top_level_tag,@mdc_with_ids,@mdc_with_ids_success | <num>          | <num>,<param1>,<param2> | test_10002.<num> |
    Then the MDC has the values
      | feature                 | scenario                                                | step                        | tags                                               | outline_number | outline_example         | test_id          |
      | mdc with test ids tests | MDC with multiple outline tables with ids - all enabled | Then the MDC has the values | @top_level_tag,@mdc_with_ids,@mdc_with_ids_success | <num>          | <num>,<param1>,<param2> | test_10002.<num> |
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

  @test#10003
  Scenario Outline: MDC with multiple outline tables with ids - some disabled
    When the MDC has the values
      | feature                 | scenario                                                  | step                        | tags                                               | outline_number | outline_example         | test_id          |
      | mdc with test ids tests | MDC with multiple outline tables with ids - some disabled | When the MDC has the values | @top_level_tag,@mdc_with_ids,@mdc_with_ids_success | <num>          | <num>,<param1>,<param2> | test_10003.<num> |
    Then the MDC has the values
      | feature                 | scenario                                                  | step                        | tags                                               | outline_number | outline_example         | test_id          |
      | mdc with test ids tests | MDC with multiple outline tables with ids - some disabled | Then the MDC has the values | @top_level_tag,@mdc_with_ids,@mdc_with_ids_success | <num>          | <num>,<param1>,<param2> | test_10003.<num> |
  @mdc_with_ids @mdc_with_ids_success
    Examples: Enabled table
      | num | param1 | param2    |
      | 1   | temp   | another   |
      | 2   | temp   | parameter |
    Examples: Disabled table
      | num          | param1       | param2       |
      | will_not_run | will_not_run | will_not_run |
  @mdc_with_ids @mdc_with_ids_success
    Examples: Another enabled table
      | num | param1 | param2      |
      | 1   | temp   | yet_another |

  @mdc_with_ids @mdc_with_ids_error @test#10004
  Scenario: MDC error with ids
    Then the MDC has the values
      | feature                 | scenario           | step                        | tags                                             | test_id    |
      | mdc with test ids tests | MDC error with ids | Then the MDC has the values | @top_level_tag,@mdc_with_ids,@mdc_with_ids_error | test_10004 |
    And the MDC has the values
      | feature                 | scenario           | step                       | tags                                             | test_id    |
      | mdc with test ids tests | MDC error with ids | And the MDC has the values | @top_level_tag,@mdc_with_ids,@mdc_with_ids_error | test_10004 |
    And false

  @mdc_with_ids @mdc_with_ids_error @test#10005
  Scenario Outline: MDC error in outline with ids
    When the MDC has the values
      | feature                 | scenario                      | step                        | tags                                             | outline_number | outline_example         | test_id          |
      | mdc with test ids tests | MDC error in outline with ids | When the MDC has the values | @top_level_tag,@mdc_with_ids,@mdc_with_ids_error | <num>          | <num>,<param1>,<param2> | test_10005.<num> |
    Then the MDC has the values
      | feature                 | scenario                      | step                        | tags                                             | outline_number | outline_example         | test_id          |
      | mdc with test ids tests | MDC error in outline with ids | Then the MDC has the values | @top_level_tag,@mdc_with_ids,@mdc_with_ids_error | <num>          | <num>,<param1>,<param2> | test_10005.<num> |
    And false
    Examples:
      | num | param1 | param2    |
      | 1   | temp   | another   |
      | 2   | temp   | parameter |

  @mdc_with_ids @mdc_with_ids_error @test#10006
  Scenario Outline: MDC with multiple outline tables with ids - all enabled
    When the MDC has the values
      | feature                 | scenario                                                | step                        | tags                                             | outline_number | outline_example         | test_id          |
      | mdc with test ids tests | MDC with multiple outline tables with ids - all enabled | When the MDC has the values | @top_level_tag,@mdc_with_ids,@mdc_with_ids_error | <num>          | <num>,<param1>,<param2> | test_10006.<num> |
    Then the MDC has the values
      | feature                 | scenario                                                | step                        | tags                                             | outline_number | outline_example         | test_id          |
      | mdc with test ids tests | MDC with multiple outline tables with ids - all enabled | Then the MDC has the values | @top_level_tag,@mdc_with_ids,@mdc_with_ids_error | <num>          | <num>,<param1>,<param2> | test_10006.<num> |
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

  @test#10007
  Scenario Outline: MDC with multiple outline tables with ids - some disabled
    When the MDC has the values
      | feature                 | scenario                                                  | step                        | tags                                             | outline_number | outline_example         | test_id          |
      | mdc with test ids tests | MDC with multiple outline tables with ids - some disabled | When the MDC has the values | @top_level_tag,@mdc_with_ids,@mdc_with_ids_error | <num>          | <num>,<param1>,<param2> | test_10007.<num> |
    Then the MDC has the values
      | feature                 | scenario                                                  | step                        | tags                                             | outline_number | outline_example         | test_id          |
      | mdc with test ids tests | MDC with multiple outline tables with ids - some disabled | Then the MDC has the values | @top_level_tag,@mdc_with_ids,@mdc_with_ids_error | <num>          | <num>,<param1>,<param2> | test_10007.<num> |
    And false
  @mdc_with_ids @mdc_with_ids_error
    Examples: Enabled table
      | num | param1 | param2    |
      | 1   | temp   | another   |
      | 2   | temp   | parameter |
    Examples: Disabled table
      | num          | param1       | param2       |
      | will_not_run | will_not_run | will_not_run |
  @mdc_with_ids @mdc_with_ids_error
    Examples: Another enabled table
      | num | param1 | param2      |
      | 1   | temp   | yet_another |
