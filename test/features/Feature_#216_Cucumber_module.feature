@epic#198 @feature#216 @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Feature #216: Cucumber module
  In order to use the toolkit in a cucumber test
  As a test developer
  I want to require all functionality in a single file

  Background: Create QAT project
    Given I copy the directory named "../../resources/qat_project" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |

  @test#1
  Scenario: Run dummy QAT project that requires a QAT World's assertions to work
    When I run `rake assertions_tests`
    Then the exit status should be 0

  @test#2
  Scenario: Run dummy QAT project that requires a QAT World's logger to work
    When I run `rake log_tests`
    Then the stdout should contain "QAT::Cucumber::World: I can log in step definitions!"
    And the exit status should be 0

  @test#3
  Scenario: Run dummy QAT project that uses configuration to work
    When I run `rake configuration_tests`
    Then the exit status should be 0

  @test#4
  Scenario: Run dummy QAT project without correct environment configured
    Given I set the environment variable to:
      | variable       | value  |
      | QAT_CONFIG_ENV | random |
    When I run `rake configuration_tests`
    Then the exit status should be 2

  @test#5
  Scenario: Run dummy QAT project that use core memory to work
    When I run `rake core_tests`
    Then the exit status should be 0

  @test#6
  Scenario: Run dummy QAT project that use hooks to work
    When I run `rake hooks_tests`
    Then the exit status should be 0

  @test#7
  Scenario: Run dummy QAT project with valid time sync configurations for localhost
    Given I set the environment variable to:
      | variable       | value     |
      | QAT_CONFIG_ENV | localhost |
    When I run `rake assertions_tests`
    Then the stdout should contain "QAT::Time: Target host is localhost, returning"
    And the exit status should be 0

  @test#8
  Scenario: Run dummy QAT project with valid time sync configurations for national ntp host
    Given I set the environment variable to:
      | variable       | value      |
      | QAT_CONFIG_ENV | valid_host |
    When I run `rake assertions_tests`
    Then the stdout should contain "QAT::Time: Synchronizing with host pt.pool.ntp.org using ntp method"
    And the exit status should be 0

  @test#9
  Scenario: Run dummy QAT project with valid time sync configurations for foreign ntp host
    Given I set the environment variable to:
      | variable       | value        |
      | QAT_CONFIG_ENV | foreign_host |
    When I run `rake assertions_tests`
    Then the stdout should contain "QAT::Time: Synchronizing with host nz.pool.ntp.org using ntp method"
    And the exit status should be 0

  Scenario: Run dummy QAT project with valid time sync configurations for SSH host
    Given I set the environment variable to:
      | variable       | value    |
      | QAT_CONFIG_ENV | ssh_host |
    When I run `rake assertions_tests`
    Then the stdout should contain "QAT::Time: Synchronizing with host localhost using ssh method"
    And the exit status should be 0

  @test#10
  Scenario: Run dummy QAT project with invalid time sync configurations and kill option
    Given I set the environment variable to:
      | variable       | value             |
      | QAT_CONFIG_ENV | invalid_host_kill |
    When I run `rake assertions_tests`
    Then the stderr should contain "no address for thisdoesnotexists.domain (Resolv::ResolvError)"
    And the exit status should be 2

  @test#11
  Scenario: Run dummy QAT project with invalid time sync configurations and don't kill option
    Given I set the environment variable to:
      | variable       | value                |
      | QAT_CONFIG_ENV | invalid_host_no_kill |
    When I run `rake assertions_tests`
    Then the stdout should contain "QAT::Cucumber: Synchronization failed but proceeding anyway! [(Resolv::ResolvError) no address for thisdoesnotexists.domain]"
    And the exit status should be 0

  @test#12
  Scenario: Run dummy QAT project with empty jenkins configurations file
    Given I set the environment variable to:
      | variable    | value     |
      | JENKINS_URL | localhost |
    And I set the environment variable to:
      | variable       | value      |
      | QAT_CONFIG_ENV | in_jenkins |
    When I run `rake assertions_tests`
    Then the stdout should contain "QAT::Cucumber: Configuring Jenkins with default options."
    And the exit status should be 0

  @test#13
  Scenario: Run dummy QAT project with jenkins configurations file for adding variables
    Given I have the following environment variables
      | QAT_CONFIG_ENV      | JENKINS_URL | BUILD_NUMBER | BUILD_URL | NODE_NAME | JOB_NAME | SVN_REVISION | GIT_COMMIT | EXECUTOR_NUMBER |
      | in_jenkins_add_vars | localhost   | 123          | localhost | master    | tests    | 1234578      | 123abc     | 2               |
    When I run `rake jenkins_add_vars_tests`
    Then the exit status should be 0

  @test#14
  Scenario: Run dummy QAT project with jenkins configurations file for ignoring variables
    Given I have the following environment variables
      | QAT_CONFIG_ENV         | JENKINS_URL | BUILD_NUMBER | BUILD_URL | NODE_NAME | JOB_NAME | SVN_REVISION | GIT_COMMIT | EXECUTOR_NUMBER |
      | in_jenkins_ignore_vars | localhost   | 123          | localhost | master    | tests    | 1234578      | 123abc     | 2               |
    When I run `rake jenkins_ignore_vars_tests`
    Then the exit status should be 0

  @test#15
  Scenario: Run dummy QAT project with jenkins configurations file for adding and ignoring variables
    Given I have the following environment variables
      | QAT_CONFIG_ENV        | JENKINS_URL | BUILD_NUMBER | BUILD_URL | NODE_NAME | JOB_NAME | SVN_REVISION | GIT_COMMIT | EXECUTOR_NUMBER |
      | in_jenkins_mixed_vars | localhost   | 123          | localhost | master    | tests    | 1234578      | 123abc     | 2               |
    When I run `rake jenkins_mixed_vars_tests`
    Then the exit status should be 0
