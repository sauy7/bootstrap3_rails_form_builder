require 'bootstrap3_rails_form_builder/engine'
require 'bootstrap3_rails_form_builder/form_builder'
require 'bootstrap3_rails_form_builder/helper'
require 'bootstrap3_rails_form_builder/version'

module Bootstrap3RailsFormBuilder
end

ActionView::Base.send :include, Bootstrap3RailsFormBuilder::Helper
