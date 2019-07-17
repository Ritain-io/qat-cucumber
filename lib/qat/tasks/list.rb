#!/usr/bin/env rake
#encoding: utf-8
require 'cucumber'
require 'cucumber/rake/task'
require 'rake/testtask'
require_relative '../formatter/scenario/name'
require_relative '../formatter/tags'

namespace :qat do
  namespace :list do
    desc 'Lists scenarios by tag'
    task :by_tag, :tag do |_, params|
      tag = params[:tag]
      raise ArgumentError.new "A tag is needed to execute the task!" unless tag
      raise ArgumentError.new "Tag '#{tag}' is invalid!" unless tag.start_with?('@')
      ENV['CUCUMBER_OPTS'] = nil
      Cucumber::Rake::Task.new('by_tag', 'Lists scenarios by tag') do |task|
        task.cucumber_opts = ['--no-profile',
                              '--dry-run',
                              '--format', 'QAT::Formatter::Scenario::Name',
                              '--tags', tag]
        task.fork          = false
      end.runner.run
    end

    desc 'List all scenarios without tags'
    task :untagged do
      ENV['CUCUMBER_OPTS'] = nil
      Cucumber::Rake::Task.new('untagged', 'List all scenarios without tags') do |task|
        task.cucumber_opts = ['--no-profile',
                              '--dry-run',
                              '--format', 'QAT::Formatter::Tags']
        task.fork          = false
      end.runner.run
    end

    desc 'List all duplicated names for scenarios'
    task :dup_names, [:path] do |_, args|
      ENV['CUCUMBER_OPTS'] = nil
      Cucumber::Rake::Task.new('dup_names', 'List all duplicated names for scenarios') do |task|
        task.cucumber_opts = [args[:path],
                              '--no-profile',
                              '--dry-run',
                              '--format', 'QAT::Formatter::Scenario::Name',
                              '--out', 'scenarios.json'].compact
        task.fork          = false
      end.runner.run
    end
  end
end