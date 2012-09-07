pluginPath = File.dirname(__FILE__) + "/plugins/AssetPipeline/"
require pluginPath + "wheels.rb"
require pluginPath + "sprockets.rb"
require "coffee_script"
require "less"
require "sprockets"

sprockets = Sprockets.env

map '/assets' do
  run sprockets
end