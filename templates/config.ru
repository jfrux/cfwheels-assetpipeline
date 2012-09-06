require 'sprockets'
require 'coffee_script'
map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'app/assets/javascripts'
  environment.append_path 'app/assets/stylesheets'
  environment.append_path 'vendor/assets/javascripts'
  environment.append_path 'vendor/assets/stylesheets'
  environment.append_path 'lib/assets/javascripts'
  environment.append_path 'lib/assets/stylesheets'
  run environment
end