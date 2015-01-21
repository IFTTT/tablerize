require './lib/tablerize/version'

Gem::Specification.new do |gem|
  gem.name          = 'tablerize'
  gem.summary       = 'Say goodbye to aligning tables in Markdown.'
  gem.description   = <<-END
      Tablerize is a format for writing tables using YAML/JSON-compatible data
      structures, and Ruby code to convert it to HTML.
    END

  gem.version       = Tablerize::VERSION

  gem.homepage      = 'https://github.com/IFTTT/tablerize'
  gem.authors       = ['Sean Zhu']
  gem.email         = 'opensource+tablerize@szhu.me'
  gem.license       = 'MIT'

  gem.required_ruby_version = '>= 1.9.3'
  gem.add_dependency 'kramdown', '~> 1.2', '>= 1.2.0'
  gem.executables   = ['tablerize']
  gem.files         = `git ls-files`.split
  gem.require_paths = ['lib']
end
