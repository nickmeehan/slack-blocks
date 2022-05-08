# frozen_string_literal: true

require_relative 'image'
require_relative 'markdown'
require_relative 'plain_text'

# Supports the Context object.
#
# @see https://api.slack.com/reference/block-kit/blocks#context
module SlackBlocks
  class Context
    MAX_ELEMENTS_SIZE = 10
    VALID_BLOCK_KLASSES = [
      SlackBlocks::Image,
      SlackBlocks::Markdown,
      SlackBlocks::PlainText
    ].to_set

    # Cache this so we don't ever have to compute this on the fly.
    VALID_BLOCK_KLASS_STRINGS = VALID_BLOCK_KLASSES.join(', ')

    def initialize(elements: [])
      if elements.size > MAX_ELEMENTS_SIZE
        raise SlackBlocks::TooManyElements, "the maximum number of elements for a Context block is #{MAX_ELEMENTS_SIZE}"
      end
      @elements = elements
    end

    def <<(incoming_element_block)
      validate_block_klass(incoming_element_block)
      validate_block_addition

      @elements << incoming_element_block
    end

    def as_json
      {
        'type' => 'context',
        'elements' => @elements.map(&:as_json)
      }
    end

    private

    def validate_block_klass(incoming_element_block)
      # We check the incoming element block's class to ensure it's valid.
      unless VALID_BLOCK_KLASSES.include?(incoming_element_block.class)
        raise SlackBlocks::InvalidBlockType,
          "#{incoming_element_block.class} is not valid to be used in a Context block, valid block types are #{VALID_BLOCK_KLASS_STRINGS}"
      end
    end

    def validate_block_addition
      # We check the current size to see if the @elements array can fits anymore.
      if @elements.size >= MAX_ELEMENTS_SIZE
        raise SlackBlocks::TooManyElements, "the maximum number of elements for a Context block is #{MAX_ELEMENTS_SIZE}"
      end
    end
  end
end
