# frozen_string_literal: true

require_relative "lib/kdwatch/version"

Gem::Specification.new do |spec|
  spec.name          = "kdwatch"
  spec.version       = Kdwatch::VERSION
  spec.authors       = ["Carsten Bormann"]
  spec.email         = ["cabo@tzi.org"]

  spec.summary       = "kdwatch: open auto-reloaded HTML for kramdown-rfc in a browser."
  spec.description   = "kdwatch: open auto-reloaded HTML for kramdown-rfc in a browser."
  spec.homepage      = "https://github.com/cabo/kdwatch"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.executables   = ['kdwatch']
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler", '~> 2.2'
  spec.add_dependency "thin", '~> 1.8'
  spec.add_dependency "guard-livereload", '~> 2.5' #, require: false
  spec.add_dependency "rack-livereload", '~> 0.3'
  spec.add_dependency "guard", '~> 2.17'
  spec.add_dependency "sinatra", '~> 2.1'
  spec.add_dependency "kramdown-rfc2629", '~> 1.4'
  spec.add_dependency "net-http-persistent", '~> 4.0'
end
