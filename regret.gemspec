# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'regret/version'

Gem::Specification.new do |spec|
  spec.name    = 'regret'

  # Do not change the version and date fields by hand. This will be done
  # automatically by the gem release script.
  spec.version = Regret::VERSION

  spec.summary     = "Testing image"
  spec.description = <<-EOT
    Testing image
  EOT

  spec.authors  = ['']
  spec.email    = ['']
  spec.homepage = ''
  spec.license  = 'MIT'

  spec.add_dependency 'chunky_png'

  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec', '~> 3')
  spec.add_development_dependency('capybara')
  spec.add_development_dependency('poltergeist')
  spec.add_development_dependency('byebug')

  spec.rdoc_options << '--title' << spec.name << '--main' << 'README.rdoc' << '--line-numbers' << '--inline-source'
  spec.extra_rdoc_files = ['README.md', 'BENCHMARKING.rdoc', 'CONTRIBUTING.rdoc', 'CHANGELOG.rdoc']

  spec.files = `git ls-files`.split($/)
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
end
