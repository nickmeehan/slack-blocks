# frozen_string_literal: true

# Supports both types of Image objects:
# 1. The block element to be used unnested.
# 2. The block element used in section and context blocks.
#
# Please ensure you are aware of the arguments you are passing. If
# using in a section or context, adding a title will make the JSON
# invalid.
#
# @see https://api.slack.com/reference/block-kit/blocks#image
# @see https://api.slack.com/reference/block-kit/block-elements#image
module SlackBlocks
  class Image
    # TODO: Add in block_id as an argument.
    def initialize(image_url:, alt_text:, title: nil)
      @image_url = image_url
      @alt_text = alt_text
      @title =
        if title.is_a?(String)
          SlackBlocks::PlainText.new(text: title)
        elsif title.is_a?(SlackBlocks::PlainText)
          title
        else
          # Explicitly handle the case of being the default, nil.
          title
        end
    end

    def as_json
      {
        'type' => 'image',
        'image_url' => @image_url,
        'alt_text' => @alt_text,
        'title' => @title&.as_json
      }.compact
    end
  end
end
