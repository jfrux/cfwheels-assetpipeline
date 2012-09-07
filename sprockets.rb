module Sprockets
  def self.env
    @env ||= begin
      sprockets = Sprockets::Environment.new

      ['stylesheets', 'javascripts', 'images'].each do |dir|
        sprockets.append_path(File.join('app', 'assets', dir))
        sprockets.append_path(File.join('vendor', 'assets', dir))
        #sprockets.append_path(File.join('lib', 'assets', dir))
      end

      puts sprockets.cache

      sprockets
    end
  end

  def self.manifest
    @manifest ||= Sprockets::Manifest.new(env, Wheels.root.join("public", "assets", "manifest.json"))
  end

  def self.paths_for_manifests(manifests = [])
    manifests.map do |manifest|
      env[manifest].dependencies.map{|d| "/assets/#{d.logical_path}"}
    end.flatten
  end

end
