# frozen_string_literal: true

# Supports the PlainText Text object.
#
# @see https://api.slack.com/reference/block-kit/composition-objects#text
module SlackBlocks
  class PlainText
    def initialize(text:, emoji: nil)
      @text = text
      @emoji = emoji
    end

    def as_json
      {
        'type' => 'plain_text',
        'text' => @text,
        'emoji' => @emoji
      }.compact
    end
  end
end
