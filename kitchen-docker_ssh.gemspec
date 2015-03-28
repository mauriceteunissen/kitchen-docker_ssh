# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kitchen/driver/docker_ssh_version'

Gem::Specification.new do |spec|
  spec.name          = 'kitchen-docker_ssh'
  spec.version       = Kitchen::Driver::DOCKER_SSH_VERSION
  spec.authors       = ['Peter Abbott']
  spec.email         = ['peter@piemanpete.com']
  spec.description   = %q{A Test Kitchen Driver for DockerSsh}
  spec.summary       = spec.description
  spec.homepage      = 'http://github.com/peterabbott/kitchen-docker_ssh/'
  spec.license       = 'Apache 2.0'

  spec.files         = `git ls-files`.split($/) -  %w( .gitignore support ) + %w( lib/kitchen/driver/VERSION )
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/}) 
  spec.require_paths = ['lib']

  spec.add_dependency 'test-kitchen', '~> 1.3.1'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'

  spec.add_development_dependency 'cane'
  spec.add_development_dependency 'tailor'
  spec.add_development_dependency 'countloc'

  spec.add_development_dependency "rspec","~> 3.2"
end
