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
    collection_name('elements')

    def initialize(elements: [])
      @elements = elements
      validate_collection_size
      validate_collection_contents
    end

    def as_json
      {
        'type' => 'context',
        'elements' => @elements.map(&:as_json)
      }
    end
  end
end
