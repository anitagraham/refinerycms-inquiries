#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

ENGINE_PATH = File.dirname(__FILE__)
APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)

if File.exists?(APP_RAKEFILE)
  load 'rails/tasks/engine.rake'
end

require "refinerycms-testing"
Refinery::Testing::Railtie.load_dummy_tasks(ENGINE_PATH)

puts "Loading rspec.rake"
load File.expand_path('../tasks/rspec.rake', __FILE__)
puts "Loading setup_extension.rake"
load File.expand_path('../tasks/setup_extension.rake', __FILE__)

task :default => :spec


