# frozen_string_literal: true

require_relative 'image'
require_relative 'markdown'
require_relative 'plain_text'

# Supports the Context object.
#
# @see https://api.slack.com/reference/block-kit/blocks#context
module SlackBlocks
  class Context
    include Collectable

    max_collection_size(10)
    valid_block_klasses(SlackBlocks::Image, SlackBlocks::Markdown, SlackBlocks::PlainText)
    collection_instance_variable_name('@elements')

    def initialize(elements: [])
      # TODO: Change these into helpers, or adapt the current ones for dual purpose use.
      if elements.size > max_collection_size
        raise SlackBlocks::TooManyElements, "the maximum number of elements for a Context block is #{max_collection_size}"
      end
      elements.each do |element_block|
        validate_incoming_klass(element_block.class)
      end
      @elements = elements
    end

    def as_json
      {
        'type' => 'context',
        'elements' => @elements.map(&:as_json)
      }
    end
  end
end
