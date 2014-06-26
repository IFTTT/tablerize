require 'kramdown/parser/kramdown'

module Kramdown
  module Parser
    class KramdownYamlTablerize < ::Kramdown::Parser::Kramdown
      def initialize(source, options)
        super
        @block_parsers.unshift(:yaml_table)
      end

      # @private
      YAML_TABLE_PATTERN = /^#{OPT_SPACE}---[ \t]*table[ \t]*---(.*?)---[ \t]*\/table[ \t]*---/m

      # Do not use this method directly, it's used internally by Kramdown.
      # @api private
      def parse_yaml_table
        @src.pos += @src.matched_size
        @tree.children << Element.new(:yaml_table, @src[1])
      end
      define_parser(:yaml_table, YAML_TABLE_PATTERN)
    end
  end
end
