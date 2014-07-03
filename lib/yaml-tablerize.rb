require 'yaml'
require 'erb'
include ERB::Util
require_relative 'yaml-tablerize/html_element'

module YamlTablerize
  # This method can easily be replaced to use any other Markdown library.
  # As of now, you'll have to manually modify this method.
  def self.markdown(text)
    require 'kramdown'
    Kramdown::Document.new(text).to_html.strip
  end

  # Process markdown, without surrounding one-liners with <p>...</p>.
  def self.markdown_strip(text)
    html = markdown text
    p_start = '<p>'
    p_end = '</p>'
    if html.start_with?(p_start) && html.end_with?(p_end) &&
       html.scan(p_start).count == 1 && html.scan(p_end).count == 1
      html[3...-4]
    else
      html
    end
  end

  # Tablerizes a YAML file, returning a YamlTablerize::HtmlElement.
  def self.load_file(path)
    data = YAML.load_file path
    make_table(data)
  end

  # Tablerizes a YAML string, returning a YamlTablerize::HtmlElement.
  def self.load(content)
    data = YAML.load content
    make_table(data)
  end

  # Tablerizes an object, returning a YamlTablerize::HtmlElement.
  def self.make_table(data)
    table = HtmlElement.new('table', class: data['class'])
    tbody = HtmlElement.new('tbody')
    tbody.children << NEWLINE
    cols = data['cols']
    data['data'].each do |row|
      tr = HtmlElement.new('tr', class: row['class'])
      cols.each do |col|
        td = HtmlElement.new('td', class: col['class'])
        col_key = col['name']
        if (col_class_prefix = table.classes[0])
          td.add_class "#{col_class_prefix}-#{col_key}"
        end
        cell = row[col_key]
        if cell.is_a?(Hash)
          td.children << NEWLINE
          td.children << make_table(cell)
          td.children << NEWLINE
        else
          td.children << RawHtmlElement.new(markdown_strip cell)
        end
        tr.children << td
      end
      tbody.children << tr
      tbody.children << NEWLINE
    end
    table.children << tbody
    table
  end
end
