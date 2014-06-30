require './lib/yaml-tablerize/version'

Gem::Specification.new do |gem|
  gem.name        = 'yaml-tablerize'
  gem.version     = YamlTablerize::YAML_TABLERIZE_VERSION
  gem.date        = '2014-06-30'
  gem.add_dependency 'kramdown', '~> 1.2.0'
  gem.summary     = 'Convert YAML to HTML tables.'
  gem.description = 'Convert YAML to HTML tables.'
  spec.description = <<-END
      YAML Tablerize converts YAML to HTML Tables.
      Say goodbye to aligning tables in Markdown.
    END
  gem.authors     = ['Sean Zhu']
  gem.email       = 'sean.zhu@ifttt.com'
  gem.files       = `git ls-files`.split($RS)
  gem.homepage    = 'https://github.com/IFTTT/yaml-tablerize'
  gem.license     = nil
  gem.require_paths = ["lib"]
end
