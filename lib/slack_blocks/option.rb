# frozen_string_literal: true

# Supports the Option composition object.
#
# @see https://api.slack.com/reference/block-kit/composition-objects#option
module SlackBlocks
  class Option

    def initialize(
      text:,
      value:,
      description: nil,
      url: nil
    )
      # Default text to a PlainText object.
      @text =
        if text.is_a?(String)
          SlackBlocks::PlainText.new(text: text)
        elsif text.is_a?(SlackBlocks::PlainText)
          text
        elsif text.is_a?(SlackBlocks::Markdown)
          text
        else
          fail ArgumentError, 'must pass a String, SlackBlocks::PlainText object or SlackBlocks::Markdown object to text keyword argument'
        end
      @value = value
      @description =
        if description.is_a?(String)
          SlackBlocks::PlainText.new(text: description)
        elsif description.is_a?(SlackBlocks::PlainText)
          description
        else
          description
        end
      @url = = url
    end

    def ==(other_option)
      self.as_json == other_option.as_json
    end

    def as_json
      {
        'text' => @text.as_json,
        'value' => @value,
        'description' => @description&.as_json,
        'url' => @url
      }.compact
    end
  end
end
