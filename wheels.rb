require 'pathname'
module Wheels
	def self.root
		Pathname.new(File.expand_path '../..', __FILE__)
	end
end