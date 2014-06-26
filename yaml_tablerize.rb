require_relative 'lib/kramdown-yaml-tablerize/yaml_tablerize'

if ARGV.empty?
  puts 'usage: ruby yaml_tablerize.rb path/to/yaml-table.yaml ...'
  exit 1
else
  ARGV.each do |path|
    puts YamlTablerize.load_file path
  end
end
