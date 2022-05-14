# frozen_string_literal: true

# Supports the Button element.
#
# @see https://api.slack.com/reference/block-kit/block-elements#button
module SlackBlocks
  class Button
    DANGER_STYLE = 'danger'
    PRIMARY_STYLE = 'primary'

    def initialize(
      action_id:,
      text:,
      url: nil,
      value: nil,
      confirm: nil,
      accessibility_label: nil,
      primary: false,
      danger: false
    )
      fail ArgumentError, 'buttons may be primary or danger, not both' if primary && danger
      @action_id = action_id
      @text =
        if text.is_a?(String)
          SlackBlocks::PlainText.new(text: text)
        elsif text.is_a?(SlackBlocks::PlainText)
          text
        else
          fail ArgumentError, 'must pass a String or SlackBlocks::PlainText to text keyword argument'
        end
      @url = url
      @value = value
      @confirm = confirm
      @accessibility_label = accessibility_label
      @style =
        if primary
          PRIMARY_STYLE
        elsif danger
          DANGER_STYLE
        end
    end

    def as_json
      {
        'type' => 'button',
        'action_id' => @action_id,
        'text' => @text.as_json,
        'url' => @url,
        'value' => @value,
        'confirm' => @confirm&.as_json,
        'accessibility_label' => @accessibility_label,
        'style' => @style
      }.compact
    end
  end
end
