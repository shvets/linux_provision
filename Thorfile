#!/usr/bin/env ruby

unless defined? Thor::Runner
  require 'bundler'

  gems = Bundler::Definition.build(Bundler.default_gemfile, Bundler.default_lockfile, nil).requested_specs

  gem = gems.find { |gem| gem.name == 'thor'}

  load "#{ENV['GEM_HOME']}/gems/#{gem.name}-#{gem.version}/bin/thor"
end

require 'thor'

Dir.glob("thor/**/*.thor") do |name|
  Thor::Util.load_thorfile(name)
end

# $LOAD_PATH.unshift File.expand_path("lib", File.dirname(__FILE__))
