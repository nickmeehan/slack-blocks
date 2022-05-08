# frozen_string_literal: true

# Supports the Header object.
#
# @see https://api.slack.com/reference/block-kit/blocks#header
module SlackBlocks
  class Header
    # TODO: Add in block_id as an argument.
    def initialize(text:)
      @text = SlackBlocks::PlainText.new(text: text)
    end

    def as_json
      {
        'type' => 'header',
        'text' => @text.as_json
      }
    end
  end
end
