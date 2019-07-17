@epic#198 @feature#219 @user_story#230 @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Feature #219: CLI for project control: User Story #230: List installed modules
  In order to know which modules are available
  As a test developer
  I want to list all the toolkit's installed modules using the CLI utility

  Background: Install gem
    Given the "qat" gem is installed

  @test#35
  Scenario: List available modules minimal option
    When I successfully run `qat -l`
    Then the stdout should contain all of these lines:
      | List of available modules: |
      | \tcore                     |

  @test#36
  Scenario: List available modules complete option
    When I successfully run `qat --list`
    Then the stdout should contain all of these lines:
      | List of available modules: |
      | \tcore                     |

  @test#37
  Scenario: List other available modules
    Given the "logger" gem is installed
    When I successfully run `qat --list`
    Then the stdout should contain all of these lines:
      | List of available modules: |
      | \tcore                     |
      | \tlogger                   |
