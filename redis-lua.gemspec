# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redis/lua'

Gem::Specification.new do |spec|
  spec.name          = 'redis-lua'
  spec.version       = Redis::Lua::Version
  spec.authors       = ["Chris Hanks"]
  spec.email         = ['christopher.m.hanks@gmail.com']
  spec.description   = %q{A few more methods for the Redis class to make Lua script usage cleaner.}
  spec.summary       = %q{Cleaner Lua script usage with redis-rb.}
  spec.homepage      = 'https://github.com/chanks/redis-lua'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
