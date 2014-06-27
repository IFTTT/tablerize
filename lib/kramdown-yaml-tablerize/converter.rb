require 'psych'
require_relative 'yaml_tablerize'

module Kramdown
  module Converter
    class Html
      # @return [String] an HTML fragment representing this element
      # @api private
      def convert_yaml_table(el, _indent)
        YamlTablerize.load el.value
      rescue Psych::SyntaxError => e
        $stderr.puts "Tablerizer: YAML error for the following table:"
        $stderr.puts yaml_error_context el, e
        $stderr.puts "backtrace:"
        raise e
      end

      private

      def yaml_error_context(el, e)
        line_number = 0
        el.value.lines
          .map { |line| "#{line_number += 1} #{line.chomp}" }[ [0, e.line - 5].max .. e.line + 5].join "\n"
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
