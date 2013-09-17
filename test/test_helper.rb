# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'rails/test_help'

require 'timecop'

if ENV["RM_INFO"]
  require 'minitest/reporters'
  MiniTest::Reporters.use!
else
  require 'minitest/wscolor'
end

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
