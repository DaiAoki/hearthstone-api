lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hearthstone/version"

Gem::Specification.new do |spec|
  spec.name          = "hearthstone-api"
  spec.version       = Hearthstone::VERSION
  spec.authors       = ["DaiAoki"]
  spec.email         = ["a.dai.0814ap@gmail.com"]

  spec.summary       = "Hearthstone API"
  spec.description   = "Hearthstone API Wrapper by Ruby which presents API client for getting card, deck, metadata and so on. "
  spec.homepage      = "https://github.com/DaiAoki/hearthstone-api"
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 2.0.0'

  # spec.metadata["allowed_push_host"] = "https://github.com/DaiAoki/hearthstone-api"

  spec.metadata["homepage_uri"] = "https://hearthstone-app.com"
  spec.metadata["source_code_uri"] = "https://github.com/DaiAoki/hearthstone-api"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

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
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rubocop", "~> 0.58.1"
  spec.add_development_dependency "dotenv", '~> 2.1', '>= 2.1.1'

  spec.add_dependency "faraday", "~> 0.9.2"
end
