require_relative 'tablerize/version'
require_relative 'tablerize/html_element'

require 'yaml'

module Tablerize
  # Tablerizes a YAML file, returning a Tablerize::HtmlElement.
  def self.load_file(path)
    data = YAML.load_file path
    make_table(data)
  end

  # Tablerizes a YAML string, returning a Tablerize::HtmlElement.
  def self.load(content)
    data = YAML.load content
    make_table(data)
  end

  # Tablerizes an object, returning a Tablerize::HtmlElement.
  def self.make_table(data)
    table = StructuredHtmlElement.new('table', class: data['class'])
    tbody = StructuredHtmlElement.new('tbody')
    tbody.children << NEWLINE
    cols = data['cols']
    data['data'].each do |row|
      tr = StructuredHtmlElement.new('tr', class: row['class'])
      cols.each do |col|
        td = StructuredHtmlElement.new('td', class: col['class'])
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

  private

  # This method can easily be replaced to use any other Markdown library.
  # As of now, you'll have to manually modify this method.
  def self.markdown(text)
    require 'kramdown'
    Kramdown::Document.new(text).to_html.strip
  end

  # Process markdown removing <p>...</p> from one-liners.
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
end
