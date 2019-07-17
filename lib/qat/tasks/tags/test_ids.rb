#!/usr/bin/env rake
#encoding: utf-8
require 'cucumber'
require 'cucumber/rake/task'
require 'rake/testtask'
require 'json'
require 'fileutils'
require 'awesome_print'
require_relative '../../formatter/test_ids'
require_relative 'test_ids/report'
require_relative 'test_ids/helpers'

namespace :qat do
  namespace :tags do
    def run_report_task!
      begin
        Rake::Task['qat:tags:report_test_ids'].invoke
      rescue SystemExit => exception
        exitstatus = exception.status
        @kernel.exit(exitstatus) unless exitstatus == 0
      end
    end

    desc 'Generates the test id report in JSON'
    task :report_test_ids do
      FileUtils.mkdir('public') unless File.exists?(File.join(Dir.pwd, 'public'))
      ENV['CUCUMBER_OPTS'] = nil
      Cucumber::Rake::Task.new('test_ids', 'Generates test ids as tags for tests without test id') do |task|
        task.bundler       = false
        task.fork          = false
        task.cucumber_opts = ['--no-profile',
                              '--dry-run',
                              '--format', 'QAT::Formatter::TestIds',
                              '--out', 'public/test_ids.json']
      end.runner.run
    end

    desc 'Validates the existing test ids and checks for duplicates'
    task :validate_test_ids do
      run_report_task!
      #read json file
      file_path = File.realpath(File.join(Dir.pwd, 'public', 'test_ids.json'))
      report    = TestIds::Report.new(file_path)

      exitstatus = report.duplicate.any? ? 1 : 0

      exit(exitstatus)
    end

    desc 'Generates test ids as tags for tests without test id'
    task :test_ids do
      run_report_task!
      #read json file
      file_path = File.realpath(File.join(Dir.pwd, 'public', 'test_ids.json'))
      report    = TestIds::Report.new(file_path)

      report.tag_untagged!
    end
  end
end