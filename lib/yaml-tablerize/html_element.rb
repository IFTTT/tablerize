module YamlTablerize
  # A piece of raw HTML inside a HtmlElement-like object that responds to to_html.
  class RawHtmlElement
    attr_reader :html
    alias_method :to_html, :html

    def initialize(html)
      @html = html
    end
  end
  NEWLINE = RawHtmlElement.new("\n")

  # Class for constructing arbitrary non-self-closing HTML elements.
  class HtmlElement
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
      @classes << klass unless @classes.include? klass
    end

    def attrs_html(attrs)
      out = ''
      out << %( class="#{h @classes.join ' '}")  if @classes.length > 0
      attrs.each do |attr, value|
        out << %( #{attr}="#{h value}")
      end
      out
    end

    def inner_html
      @children.map { |child| child.to_html }.join ''
    end
  end
end
