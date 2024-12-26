Gem::Specification.new do |spec|
  spec.name          = "zru-ruby"
  spec.version       = "1.0.0"
  spec.authors       = ["ZRU"]
  spec.email         = ["support@zrupay.com"]
  spec.summary       = "ZRU Ruby Gem"
  spec.description   = %q{Gem for the ZRU API.}
  spec.homepage      = "https://www.zrupay.com"
  spec.license       = "MIT"

  spec.files         = Dir["{lib, bin}/**/*", "LICENSE.txt", "README.md"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.executables   = ['zru']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'unirest', '~> 1.0'
end