# frozen_string_literal: true

# Supports the Markdown Text object.
#
# @see https://api.slack.com/reference/block-kit/composition-objects#text
module SlackBlocks
  class Markdown
    def initialize(text:, verbatim: false)
      @text = text
      @verbatim = verbatim
    end

    def as_json
      {
        'type' => 'mrkdwn',
        'text' => @text,
        'verbatim' => @verbatim
      }
    end
  end
end
