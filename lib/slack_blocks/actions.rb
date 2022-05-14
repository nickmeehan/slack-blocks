# frozen_string_literal: true

require_relative 'button'

# Supports the Actions object.
#
# @see https://api.slack.com/reference/block-kit/blocks#actions
module SlackBlocks
  class Actions
    MAX_ELEMENTS_SIZE = 25
    VALID_BLOCK_KLASSES = [
      SlackBlocks::Button,
    ].to_set

    # Cache this so we don't ever have to compute this on the fly.
    VALID_BLOCK_KLASS_STRINGS = VALID_BLOCK_KLASSES.join(', ')

    def initialize(elements: [])
      # TODO: Change these into helpers, or adapt the current ones for dual purpose use.
      if elements.size > MAX_ELEMENTS_SIZE
        raise SlackBlocks::TooManyElements, "the maximum number of elements for an Actions block is #{MAX_ELEMENTS_SIZE}"
      end
      elements.each do |element_block|
        validate_block_klass(element_block)
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
        'type' => 'actions',
        'elements' => @elements.map(&:as_json)
      }
    end

    private

    def validate_block_klass(incoming_element_block)
      # We check the incoming element block's class to ensure it's valid.
      unless VALID_BLOCK_KLASSES.include?(incoming_element_block.class)
        raise SlackBlocks::InvalidBlockType,
          "#{incoming_element_block.class} is not valid to be used in an Actions block, valid block types are #{VALID_BLOCK_KLASS_STRINGS}"
      end
    end

    def validate_block_addition
      # We check the current size to see if the @elements array can fits anymore.
      if @elements.size >= MAX_ELEMENTS_SIZE
        raise SlackBlocks::TooManyElements, "the maximum number of elements for an Actions block is #{MAX_ELEMENTS_SIZE}"
      end
    end
  end
end
