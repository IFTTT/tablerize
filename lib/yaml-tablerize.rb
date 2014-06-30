require 'yaml'
require 'erb'
include ERB::Util

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

  class RawHTMLElement
    attr_accessor :html

    def initialize(html)
      @html = html
    end
  end
  NEWLINE = RawHTMLElement.new("\n")

  class HTMLElement
    attr_accessor :tag
    attr_reader :attrs, :classes, :children

    def initialize(tag, opts = {})
      @tag = tag
      @attrs = {}
      @classes = []
      @children = []
      add_class opts[:class] unless opts[:class].nil?
      @attrs.update opts[:attrs] unless opts[:attrs].nil?
    end

    def add_class(classes)
      if classes.respond_to? :each
        classes.each do |klass|
          add_single_class klass
        end
      else
        add_single_class classes
      end
    end

    def add_single_class(klass)
      return if klass.nil? || klass.empty?
      @classes << klass unless @classes.include? klass
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
      out << %( class="#{h @classes.join ' '}")  if @classes.length > 0
      attrs.each do |attr, value|
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
          td.children << RawHTMLElement.new(markdown_strip cell)
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
