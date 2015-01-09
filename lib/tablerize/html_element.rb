require 'erb'

module Tablerize
  class HtmlElement
  end

  # A RawHtmlElement represents arbitrary HTML.
  class RawHtmlElement < HtmlElement
    attr_reader :html
    alias_method :to_html, :html

    def initialize(html)
      @html = html
    end
  end
  NEWLINE = RawHtmlElement.new("\n")

  # A StructuredHtmlElement represents HTML tags enclosing an array of
  # HtmlElements.
  class StructuredHtmlElement < HtmlElement
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

    def to_html
      "<#{tag}#{attrs_html(@attrs)}>#{inner_html}</#{tag}>"
    end

    private

    def add_single_class(klass)
      return if klass.nil? || klass.empty?
      return if @classes.include? klass
      @classes << klass
    end

    def attrs_html(attrs)
      out =  %( class="#{ERB::Util.h @classes.join(' ')}")  if @classes.length > 0
      attrs.each do |attr, value|
        out << %( #{attr}="#{h value}")
      end
      out
    end

    def inner_html
      @children.map(&:to_html).join('')
    end
  end
end
