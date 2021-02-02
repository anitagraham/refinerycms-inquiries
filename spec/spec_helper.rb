# frozen_string_literal: true

require 'rubygems'

# Configure Rails Environment
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('dummy/config/environment', __dir__)

require 'rspec/rails'
require 'capybara/rspec'
require 'webdrivers/chromedriver'
require 'refinerycms-testing'

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
  config.mock_with :rspec
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  # Should give you refinery_login
  config.extend Refinery::Testing::ControllerMacros::Authentication
  config.include ActionDispatch::TestProcess
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end
Capybara.javascript_driver = :chrome

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end
Capybara.javascript_driver = :chrome

# FactoryBot::SyntaxRunner.class_eval do
#   include ActionDispatch::TestProcess
# end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories including factories.
([Rails.root.to_s] | ::Refinery::Plugins.registered.pathnames).map do |p|
  Dir[File.join(p, 'spec', 'support', '**', '*.rb').to_s]
end.flatten.sort.each do |support_file|
  require support_file
end
