lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "something_awful/version"

Gem::Specification.new do |spec|
  spec.name          = "something_awful"
  spec.version       = SomethingAwful::VERSION
  spec.authors       = ["Jaded Burnout"]
  spec.email         = ["jaded.burnout69@gmail.com"]

  spec.summary       = %q{A client library for the SomethingAwful forums.}
  spec.homepage      = "https://github.com/jaded-burnout/something-awful"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "lib/something_awful"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "climate_control"
  spec.add_development_dependency "factory_bot"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "timecop"

  spec.add_dependency "oga"
  spec.add_dependency "http"
end
