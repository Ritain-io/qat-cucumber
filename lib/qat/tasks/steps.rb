#!/usr/bin/env rake
#encoding: utf-8
require 'cucumber'
require 'cucumber/rake/task'
require 'rake/testtask'

namespace :qat do
  namespace :steps do
    desc 'Automatic validation step definitions for test scenarios'
    task :validation do
      ENV['CUCUMBER_OPTS'] = nil
      Cucumber::Rake::Task.new('validation', 'Automatic validation step definitions for test scenarios') do |task|
        task.bundler       = false
        task.cucumber_opts = ['--no-profile',
                              '--dry-run',
                              '--format progress']
      end.runner.run
    end
  end
end