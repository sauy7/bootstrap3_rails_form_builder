$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bootstrap3_rails_form_builder/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bootstrap3_rails_form_builder"
  s.version     = Bootstrap3RailsFormBuilder::VERSION
  s.authors     = ["Tim Heighes"]
  s.email       = ["tim@heighes.com"]
  s.homepage    = "http://github.com/sauy7/bootstrap3_rails_form_builder"
  s.summary     = "Twitter Bootstrap 3 form builder for Rails 4"
  s.description = "Rails 4 engine providing form builder to easily create Twitter Bootstrap 3 forms."

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '~> 4.0.0'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'minitest-wscolor', '~> 0.0.3'
  s.add_development_dependency 'minitest-reporters', '>= 0.5.0'
  s.add_development_dependency 'timecop'
end
