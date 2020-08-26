lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'graphqlmd/version'

Gem::Specification.new do |s|
  s.name        = 'graphqlmd'
  s.version     = Graphqlmd::VERSION
  s.date        = '2020-08-26'
  s.summary     = 'graphqlmd'
  s.description = 'This gem will generate markdown by your GraphQL schema'
  s.authors     = ['Alexander Kalinichev']
  s.email       = 'alex@agileseason.com'
  s.files       = Dir.glob("{bin,lib}/**/*")
  s.executables << 'graphqlmd'
  s.require_paths = ['lib']
  s.homepage    = 'https://github.com/blackchestnut/graphqlmd'
  s.license     = 'MIT'
end
