@epic#198 @feature#219 @user_story#229 @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Feature #219: CLI for project control: User Story #229: Project stub generation
  In order to easily start a new test project
  As a test developer
  I want to create a new project stub using the CLI utility

  @test#29
  Scenario Outline: Create a new project
    When I run `qat <command> new_project`
    Then the exit status should be 0
    And a directory named "new_project" should exist
    Examples:
      | command |
      | -n      |
      | --new   |

  @test#30
  Scenario: Check Generated files
    When I run `qat -n test_project -r`
    Then a directory named "test_project" should exist
    And I cd to "test_project"
    And a file named "Rakefile" should exist
    And a file named "Gemfile" should exist
    And the file named "Rakefile" should contain "require 'qat/tasks'"
    And the following directories should exist:
      | config   |
      | features |
      | lib      |
      | public   |

    And I cd to "config"
    And the following directories should exist:
      | env-dummy |
      | common    |
    And a directory named "env-dummy" should exist
    And the following files should exist:
      | cucumber.yml |
      | default.yml  |
    And the file named "cucumber.yml" should contain:
    """
    qat: &qat >
      --format QAT::Formatter::Console
      --format html --out public/index.html
      --format junit --out public/
      --strict

    standard: &standard >
      --format html --out public/index.html
      --format junit --out features/reports

    flat: &flat --format pretty

    default: *qat
    """
    And the file named "default.yml" should contain "env: 'env-dummy'"

  @test#31
  Scenario Outline: Empty -r
    When I run `qat <command> new_project`
    Then the exit status should be 0
    And the output should not contain anything
    Examples:
      | command   |
      | -r        |
      | --verbose |

  @test#32
  Scenario Outline: Create a new project with verbose output
    When I run `qat -n new_project <command>`
    Then the exit status should be 0
    And a directory named "new_project" should exist
    And the stdout should contain "mkdir new_project"
    Examples:
      | command   |
      | -r        |
      | --verbose |

  @test#33
  Scenario: Create a new project without project name
    When I run `qat -n`
    Then the exit status should be 1
    And the stderr should contain exactly "Error: No project name given"

  @test#34
  Scenario: Create a new project that already exists
    Given a directory named "my_project"
    When I run `qat -n my_project`
    Then the exit status should be 1
    And the stderr should contain exactly "Error: The project 'my_project' already exists"

  @test#79
  Scenario: Example tests from a generated project run successfully
    When I run `qat -n test_run`
    Then the exit status should be 0
    And I cd to "test_run"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |
    When I run `cucumber`
    Then the exit status should be 0
