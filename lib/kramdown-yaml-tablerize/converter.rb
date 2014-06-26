require_relative 'yaml_tablerize'

module Kramdown
  module Converter
    class Html
      # @return [String] an HTML fragment representing this element
      # @api private
      def convert_yaml_table(el, _indent)
        YamlTablerize.load el.value
      end
    end

    class Kramdown
      def convert_yaml_table(_el, _opts)
        raise NotImplementedError
      end
    end

    class Latex
      def convert_yaml_table(_el, _opts)
        raise NotImplementedError
      end
    end
  end
end
