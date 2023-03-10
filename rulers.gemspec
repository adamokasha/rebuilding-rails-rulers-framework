
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rulers/version"

Gem::Specification.new do |spec|
  spec.name          = "rulers"
  spec.version       = Rulers::VERSION
  spec.authors       = ["Adam Okasha"]
  spec.email         = ["kasho.dev@gmail.com"]

  spec.summary       = %q{Write a short summary, because RubyGems requires one.}
  spec.description   = %q{Write a longer description or delete this line.}

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.4.1"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "rack", "~> 2.2"
  spec.add_dependency "erubis"
  spec.add_dependency "webrick"
  spec.add_dependency "rack-test"
  spec.add_dependency "minitest"
  spec.add_dependency "multi_json"
  spec.add_dependency "sqlite3", "~> 1.6.0"
end
