#!/usr/bin/env rake
#encoding: utf-8
require 'cucumber'
require 'cucumber/rake/task'
require 'rake/testtask'

namespace :qat do
  namespace :test do
    def clear_reports_folder!
      mkdir_p 'public'
      rm_rf ::File.join('public', '*')
    end

    Cucumber::Rake::Task.new('run', 'Run all test scenarios')

    desc 'Run a complete feature'
    task :feature, :feature_name do |_, params|
      feature_name = params[:feature_name]
      raise ArgumentError.new "A feature is needed to execute the task!" unless feature_name
      Cucumber::Rake::Task.new(:feature) do
        ENV['FEATURE'] = Dir.glob(File.join('features', '**', "#{feature_name}.feature")).first
      end.runner.run
    end

    desc 'Run all test scenarios containing given tags'
    task :tags, :tags do |_, params|
      tags = params[:tags].is_a?(String) ? [params[:tags]] : params[:tags].to_a
      raise ArgumentError.new "A tag is needed to execute the task!" unless tags.any?
      ENV['CUCUMBER_OPTS'] = "#{ENV['CUCUMBER_OPTS']} --tags #{tags.join(',')}"
      Cucumber::Rake::Task.new('run', 'Run all test scenarios containing given tags') do |task|
        task.bundler = false
      end.runner.run
    end
  end
end
