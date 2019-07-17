@epic#198 @feature#217
Feature: Feature #217: Jenkins module
  In order to have better continuous integration
  As a tester
  I want to enhance tests with Jenkins information

  @test#22
  Scenario: Jenkins module is not included when not in Jenkins
    Given I unset the "JENKINS_URL" environment variable
    When I load the "qat/cucumber.rb" file
    Then the "Jenkins" constant is undefined
    Given I set the "JENKINS_URL" environment variable with value "localhost.com"
    When I load the "qat/cucumber.rb" file
    Then the "Jenkins" constant is defined

  @test#23
  Scenario: Add Jenkins environment variables to MDC
    Given I reset the MDC
    And I have the following environment variables
      | BUILD_NUMBER | BUILD_URL | NODE_NAME | JOB_NAME | SVN_REVISION | GIT_COMMIT |
      | 123          | localhost | master    | tests    | 1234578      | 123abc     |
    When I register Jenkins variables
    Then the MDC has the values
      | BUILD_NUMBER | BUILD_URL | NODE_NAME | JOB_NAME | SVN_REVISION | GIT_COMMIT |
      | 123          | localhost | master    | tests    | 1234578      | 123abc     |

  @test#24
  Scenario: Ignore Jenkins environment variables
    Given I reset the MDC
    And I have the following environment variables
      | BUILD_NUMBER | BUILD_URL | NODE_NAME | JOB_NAME | SVN_REVISION | GIT_COMMIT |
      | 123          | localhost | master    | tests    | 1234578      | 123abc     |
    When I register Jenkins variables with options
      | ignore       |
      | SVN_REVISION |
    Then the MDC has the values
      | BUILD_NUMBER | BUILD_URL | NODE_NAME | JOB_NAME | SVN_REVISION | GIT_COMMIT |
      | 123          | localhost | master    | tests    | nil          | 123abc     |

  @test#25
  Scenario: Add Jenkins environment variables
    Given I reset the MDC
    And I have the following environment variables
      | BUILD_NUMBER | BUILD_URL | NODE_NAME | JOB_NAME | SVN_REVISION | GIT_COMMIT | TEST_ENV |
      | 123          | localhost | master    | tests    | 1234578      | 123abc     | QA_1     |
    When I register Jenkins variables with options
      | add      |
      | TEST_ENV |
    Then the MDC has the values
      | BUILD_NUMBER | BUILD_URL | NODE_NAME | JOB_NAME | SVN_REVISION | GIT_COMMIT | TEST_ENV |
      | 123          | localhost | master    | tests    | 1234578      | 123abc     | QA_1     |

  @test#26
  Scenario: Add and ignore Jenkins environment variables
    Given I reset the MDC
    And I have the following environment variables
      | BUILD_NUMBER | BUILD_URL | NODE_NAME | JOB_NAME | SVN_REVISION | GIT_COMMIT | TEST_ENV |
      | 123          | localhost | master    | tests    | 1234578      | 123abc     | QA_1     |
    When I register Jenkins variables with options
      | ignore       | add      |
      | SVN_REVISION | TEST_ENV |
    Then the MDC has the values
      | BUILD_NUMBER | BUILD_URL | NODE_NAME | JOB_NAME | SVN_REVISION | GIT_COMMIT | TEST_ENV |
      | 123          | localhost | master    | tests    | nil          | 123abc     | QA_1     |