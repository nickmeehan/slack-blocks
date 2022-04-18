# frozen_string_literal: true

# Supports the Markdown Text object.
#
# @see https://api.slack.com/reference/block-kit/blocks#divider
module SlackBlocks
  class Divider
    def as_json
      {
        'type' => 'divider'
      }
    end
  end
end
