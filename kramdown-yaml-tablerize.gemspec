require './lib/kramdown-yaml-tablerize/version'

Gem::Specification.new do |s|
  s.name        = 'kramdown-yaml-tablerize'
  s.version     = Kramdown::Parser::KRAMDOWN_YAML_TABLERIZE_VERSION
  s.date        = '2014-06-26'
  s.add_dependency 'kramdown', '~> 1.2.0'
  s.summary     = 'YAML to HTML tables.'
  s.description = 'Convert YAML to HTML tables, either standalone or as a Kramdown plugin.'
  s.authors     = ['Sean Zhu']
  s.email       = 'sean.zhu@ifttt.com'
  s.files       = `git ls-files`.split($/)
  # s.homepage    = nil
  # s.license     = nil
  s.require_paths = ["lib"]
end
