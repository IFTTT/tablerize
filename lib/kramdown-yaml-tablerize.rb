require 'kramdown'

module Kramdown
  # Monkey-patch Element class to include :yaml_table as a block-level element
  # @private
  class Element
    # Register :yaml_table as a block-level element
    CATEGORY[:yaml_table] = :block
  end
end

require_relative 'kramdown-yaml-tablerize/version'
require_relative 'kramdown-yaml-tablerize/parser'
require_relative 'kramdown-yaml-tablerize/converter'
