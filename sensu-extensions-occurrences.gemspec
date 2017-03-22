# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "sensu-extensions-occurrences"
  spec.version       = "1.2.0"
  spec.authors       = ["Sensu-Extensions and contributors"]
  spec.email         = ["<sensu-users@googlegroups.com>"]

  spec.summary       = "The Sensu Core built-in occurrences filter"
  spec.description   = "The Sensu Core built-in occurrences filter"
  spec.homepage      = "https://github.com/sensu-extensions/sensu-extensions-occurrences"

  spec.files         = Dir.glob('{bin,lib}/**/*') + %w(LICENSE README.md CHANGELOG.md)
  spec.require_paths = ["lib"]

  spec.add_dependency "sensu-extension"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sensu-logger"
  spec.add_development_dependency "sensu-settings"
  spec.add_development_dependency "github_changelog_generator"
end
