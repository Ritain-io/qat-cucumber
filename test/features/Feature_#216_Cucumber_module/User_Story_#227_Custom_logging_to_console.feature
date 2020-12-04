@epic#198 @feature#216 @user_story#227 @announce-directory @announce-stdout @announce-stderr @announce-output @announce-command @announce-changed-environment
Feature: Feature #216: Cucumber module: User Story #227: Custom logging to console
  In order to have more information and better context for a test execution
  As a test developer
  I want to have a custom console formatter

  Background: Create QAT project
    Given I copy the directory named "../../resources/qat_project" to "project"
    And I cd to "project"
    And I set the environment variables to:
      | variable        | value |
      | CUCUMBER_FORMAT |       |
      | CUCUMBER_OPTS   |       |

  @test#19
  Scenario: Run dummy QAT project with console formatter - check MDC is set
    Given I set the environment variable to:
      | variable      | value                            |
      | CUCUMBER_OPTS | --format QAT::Formatter::Console |
    When I run `rake mdc_success_tests`
    And the exit status should be 0

  @test#20
  Scenario: Run dummy QAT project with console formatter - check no output in dry run
    Given I set the environment variable to:
      | variable      | value                                      |
      | CUCUMBER_OPTS | --dry-run --format QAT::Formatter::Console |
    When I run `rake formatter_tests`
    Then the stdout should not contain anything
    And the exit status should be 0

  @test#21
  Scenario: Run dummy QAT project with console formatter - check output in normal run
    Given I set the environment variable to:
      | variable      | value                            |
      | CUCUMBER_OPTS | --format QAT::Formatter::Console   |
    When I run `rake formatter_tests`
    Then the output should match:
    """
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Configuration: Using directory config
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Configuration: Initializing configuration from directory config
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Running Feature: "formatter tests"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Running Scenario: "true"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[WARN \] QAT::Cucumber::Hooks::Scenario: Scenario does not have a test id! Using a dummy one...
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Cucumber::Hooks::Scenario: Scenario has test id: test_0 and test run id: test_0_\d+
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: before
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "Given true"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Formatter::Console: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after step
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "When true"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Formatter::Console: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after step
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "Then true"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Formatter::Console: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after step
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Finished Scenario: "true" - passed

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Running Scenario Outline: "Many trues #1"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[WARN \] QAT::Cucumber::Hooks::Scenario: Scenario does not have a test id! Using a dummy one...
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Cucumber::Hooks::Scenario: Scenario has test id: test_0_1 and test run id: test_0_1_\d+
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: before
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "Given true"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after step
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "When true"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Formatter::Console: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after step
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "Then true"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Formatter::Console: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after step
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "And true"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Formatter::Console: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after step
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Finished Scenario Outline: "Many trues #1" - passed

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Running Scenario Outline: "Many trues #2"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[WARN \] QAT::Cucumber::Hooks::Scenario: Scenario does not have a test id! Using a dummy one...
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Cucumber::Hooks::Scenario: Scenario has test id: test_0_2 and test run id: test_0_2_\d+
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: before
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "Given true"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after step
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "When true"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Formatter::Console: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after step
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "Then true"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Formatter::Console: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after step
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "And true"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Formatter::Console: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after step
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Finished Scenario Outline: "Many trues #2" - passed

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Running Scenario: "false"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[WARN \] QAT::Cucumber::Hooks::Scenario: Scenario does not have a test id! Using a dummy one...
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Cucumber::Hooks::Scenario: Scenario has test id: test_0 and test run id: test_0_\d+
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: before
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "Given true"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after step
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "When false"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: false
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Formatter::Console: false
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[ERROR\] QAT::Formatter::Console: Expected false to be truthy. \(Minitest::Assertion\) \[
      ".\/features\/step_definitions\/steps.rb:10:in `\/\^false\$\/'",
      "features\/formatter.feature:22:in `When false'"
    \]
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Finished Scenario: "false" - failed

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Running Scenario Outline: "Many falses #1"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[WARN \] QAT::Cucumber::Hooks::Scenario: Scenario does not have a test id! Using a dummy one...
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Cucumber::Hooks::Scenario: Scenario has test id: test_0_1 and test run id: test_0_1_\d+
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: before
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "Given true"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after step
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "Then false"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: false
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Formatter::Console: false
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[ERROR\] QAT::Formatter::Console: Expected false to be truthy. \(Minitest::Assertion\) \[
      ".\/features\/step_definitions\/steps.rb:10:in `\/\^false\$\/'",
      "features\/formatter.feature:29:in `Then false'\nfeatures\/formatter.feature:25:in `Then <false>'"
    \]
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Finished Scenario Outline: "Many falses #1" - failed

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Running Scenario Outline: "Many falses #2"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[WARN \] QAT::Cucumber::Hooks::Scenario: Scenario does not have a test id! Using a dummy one...
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Cucumber::Hooks::Scenario: Scenario has test id: test_0_2 and test run id: test_0_2_\d+
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: before
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "Given true"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after step
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "Then false"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: false
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Formatter::Console: false
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[ERROR\] QAT::Formatter::Console: Expected false to be truthy. \(Minitest::Assertion\) \[
      ".\/features\/step_definitions\/steps.rb:10:in `\/\^false\$\/'",
      "features\/formatter.feature:30:in `Then false'\nfeatures\/formatter.feature:25:in `Then <false>'"
    \]
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Finished Scenario Outline: "Many falses #2" - failed

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Running Scenario: "pending"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[WARN \] QAT::Cucumber::Hooks::Scenario: Scenario does not have a test id! Using a dummy one...
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Cucumber::Hooks::Scenario: Scenario has test id: test_0 and test run id: test_0_\d+
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: before
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "Given true"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after step
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "When pending"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: pending
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Formatter::Console: pending
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Finished Scenario: "pending" - pending

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Running Scenario Outline: "Many pending #1"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[WARN \] QAT::Cucumber::Hooks::Scenario: Scenario does not have a test id! Using a dummy one...
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Cucumber::Hooks::Scenario: Scenario has test id: test_0_1 and test run id: test_0_1_\d+
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: before
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "Given true"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after step
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "Then pending"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: pending
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Formatter::Console: pending
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Finished Scenario Outline: "Many pending #1" - pending

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Running Scenario Outline: "Many pending #2"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[WARN \] QAT::Cucumber::Hooks::Scenario: Scenario does not have a test id! Using a dummy one...
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Cucumber::Hooks::Scenario: Scenario has test id: test_0_2 and test run id: test_0_2_\d+
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: before
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "Given true"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: true
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after step
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step "Then pending"
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: pending
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Formatter::Console: pending
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Step Done!
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[DEBUG\] QAT::Cucumber::World: after
    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Finished Scenario Outline: "Many pending #2" - pending

    \d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d \[INFO \] QAT::Formatter::Console: Finished Feature: "formatter tests"
    """
    And the exit status should be 1