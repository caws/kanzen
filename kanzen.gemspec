lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "kanzen/version"

Gem::Specification.new do |spec|
  spec.name          = "kanzen"
  spec.version       = Kanzen::VERSION
  spec.authors       = ["Charles Washington"]
  spec.email         = ["charles_was_7@hotmail.com"]

  spec.summary       = %q{Kanzen evaluates how complete a model is (while taking its relationships in consideration}
  spec.description   = %q{This is a gem to be used alongside ActiveModel that gives you a sense of how complete a given model is. It checks a given model attributes, its relationships and its relationships' attributes and so on and so forth in order to check how complete it is. }
  spec.homepage      = "https://github.com/caws/kanzen"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/caws/kanzen"
  spec.metadata["changelog_uri"] = "https://github.com/caws/kanzen"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
