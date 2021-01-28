require_relative 'lib/version'

Gem::Specification.new do |spec|
  spec.name          = "movie-app"
  spec.version       = App::VERSION
  spec.authors       = ["lukejamesmorrison"]
  spec.email         = ["lukejamesmorrison@gmail.com"]

  spec.summary       = "This is a short summary"
  spec.description   = "This is a longer description"
  spec.homepage      = "https://github.com/lukejamesmorrison/movie-app"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/lukejamesmorrison/movie-app/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Gems
  spec.add_dependency "nokogiri"
  spec.add_dependency "open-uri"
  spec.add_dependency "colorize"
end
