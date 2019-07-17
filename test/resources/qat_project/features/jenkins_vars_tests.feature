Feature: Test addition of Jenkins vars to MDC

  @jenkins_add_vars
  Scenario: jenkins configurations file for adding variables
    Then the MDC has the values
      | BUILD_NUMBER | JENKINS_URL | BUILD_URL | NODE_NAME | JOB_NAME | SVN_REVISION | GIT_COMMIT | EXECUTOR_NUMBER |
      | 123          | localhost   | localhost | master    | tests    | 1234578      | 123abc     | 2               |

  @jenkins_ignore_vars
  Scenario: jenkins configurations file for ignoring variables
    Then the MDC has the values
      | BUILD_NUMBER | JENKINS_URL | BUILD_URL | NODE_NAME | JOB_NAME | SVN_REVISION | GIT_COMMIT | EXECUTOR_NUMBER |
      | 123          | nil         | localhost | master    | tests    | nil          | 123abc     | nil             |

  @jenkins_mixed_vars
  Scenario: jenkins configurations file for adding and ignoring variables
    Then the MDC has the values
      | BUILD_NUMBER | JENKINS_URL | BUILD_URL | NODE_NAME | JOB_NAME | SVN_REVISION | GIT_COMMIT | EXECUTOR_NUMBER |
      | 123          | localhost   | localhost | master    | tests    | nil          | nil        | 2               |
