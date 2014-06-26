require 'yaml'
require 'erb'
require 'kramdown'
include ERB::Util

# Convert YAML to HTML tables. This file can be used by itself; the others are all for Kramdown support.

module YamlTablerize
  # Don't surround one-liners with <p>...</p>.
  def self.kramdown(text)
    html = Kramdown::Document.new(text).to_html.strip
    p_start = '<p>'
    p_end = '</p>'
    if html.start_with?(p_start) && html.end_with?(p_end) &&
       html.scan(p_start).count == 1 && html.scan(p_end).count == 1
      html[3...-4]
    else
      html
    end
  end

  class RawHTMLElement
    attr_accessor :html

    def initialize(html)
      @html = html
    end
  end
  NEWLINE = RawHTMLElement.new("\n")

  class HTMLElement
    attr_accessor :tag
    attr_reader :attrs, :children

    def initialize(tag, opts = {})
      @tag = tag
      @attrs = { 'class' => [] }
      @children = []
      add_class opts[:class] unless opts[:class].nil?
      @attrs.update opts[:attrs] unless opts[:attrs].nil?
    end

    def add_class(klass)
      return if klass.empty?
      classes = @attrs['class']
      classes << klass unless classes.include? klass
    end

    def inner_html
      @children.map { |child| child.html }.join ''
    end

    def html
      "<#{tag}#{attrs_html(@attrs)}>#{inner_html}</#{tag}>"
    end

    private

    def attrs_html(attrs)
      out = ''
      attrs.each do |attr, value|
        if attr == 'class'
          next unless value.length > 0
          value = value.join ' '
        end
        out << %( #{attr}="#{h value}")
      end
      out
    end
  end

  def self.load_file(path)
    data = YAML.load_file path
    make_table(data).html
  end

  def self.load(content)
    data = YAML.load content
    make_table(data).html
  end

  def self.make_table(data)
    table = HTMLElement.new('table', class: data['class'])
    tbody = HTMLElement.new('tbody')
    tbody.children << NEWLINE
    cols = data['cols']
    data['data'].each do |row|
      tr = HTMLElement.new('tr', class: row['class'])
      cols.each do |col|
        td = HTMLElement.new('td', class: col['class'])
        cell = row[col['name']]
        if cell.is_a?(Hash)
          td.children << NEWLINE
          td.children << make_table(cell)
          td.children << NEWLINE
        else
          td.children << RawHTMLElement.new(kramdown cell)
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
