
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "halyk_epay/version"

Gem::Specification.new do |spec|
  spec.name          = "halyk_epay"
  spec.version       = HalykEpay::VERSION
  spec.authors       = ["marina"]
  spec.email         = ["tm20388@gmail.com"]

  spec.summary       = %q{Модуль работы с платежным шлюзом Halykbank ePay}
  spec.description   = %q{Модуль работы с платежным шлюзом Halykbank ePay}
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
end
