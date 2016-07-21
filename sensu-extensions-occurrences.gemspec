# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "sensu-extensions-occurrences"
  spec.version       = "0.0.1"
  spec.authors       = ["Sean Porter"]
  spec.email         = ["portertech@gmail.com"]

  spec.summary       = "The Sensu Core built-in occurrences filter"
  spec.description   = "The Sensu Core built-in occurrences files"
  spec.homepage      = "https://github.com/sensu-extensions/sensu-extensions-occurrences"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sensu-extension"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sensu-logger"
  spec.add_development_dependency "sensu-settings"
end
