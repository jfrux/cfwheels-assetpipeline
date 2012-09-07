pluginPath = File.dirname(__FILE__) + "/plugins/AssetPipeline/"
require 'sinatra'
require "cgi"
require pluginPath + "wheels.rb"
require pluginPath + "sprockets.rb"
require "coffee_script"
require "less"
require "sprockets"

Sinatra::Sprockets.configure do |config|
  config.app = Wheels

  ['stylesheets', 'javascripts', 'images'].each do |dir|
    config.append_path(File.join('app', 'assets', dir))
    config.append_path(File.join('vendor', 'assets', dir))
    config.append_path(File.join('lib', 'assets', dir))
  end

    
  config.digest = true
  config.compress = true
  config.debug = false

  config.precompile = ['application.js', 'vendor.js', 'application.css', /.+\.(png|ico|gif|jpeg|jpg)$/]
end
helpers Sinatra::Sprockets::Helpers

sprockets = Sprockets.env()

get '/assets' do
	run sprockets
end

# map '/manifest' do
# 	run Sprockets.paths_for_manifests(['application.js'])
# end