# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

spec = RSpec::Core::RakeTask.new(:spec)
spec.rspec_opts = "--tag ~gcloud" if ENV.fetch("GOOGLE_CLOUD_STORAGE_TEST_PROJECT", "").empty?

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[spec rubocop]
