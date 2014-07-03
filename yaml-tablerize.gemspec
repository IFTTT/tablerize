require './lib/yaml-tablerize/version'

Gem::Specification.new do |gem|
  gem.name        = 'yaml-tablerize'
  gem.summary     = 'Convert YAML to HTML tables.'
  gem.description = <<-END
      YAML Tablerize converts YAML to HTML Tables.
      Say goodbye to aligning tables in Markdown.
    END

  gem.version     = YamlTablerize::YAML_TABLERIZE_VERSION
  gem.date        = '2014-06-30'

  gem.homepage    = 'https://github.com/IFTTT/yaml-tablerize'
  gem.authors     = ['Sean Zhu']
  gem.email       = 'sean.zhu@ifttt.com'
  gem.license     = 'MIT'

  gem.add_dependency 'kramdown', '~> 1.2', '>= 1.2.0'
  gem.executables = ['yaml-tablerize']
  gem.files       = `git ls-files`.split($RS)
  gem.require_paths = ['lib']
end
