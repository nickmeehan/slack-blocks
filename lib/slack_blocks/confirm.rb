# frozen_string_literal: true

# Supports the Confirm composition object.
#
# @see https://api.slack.com/reference/block-kit/composition-objects#confirm
module SlackBlocks
  class Confirm
    DANGER_STYLE = 'danger'
    PRIMARY_STYLE = 'primary'

    def initialize(
      title:,
      dialog_text:,
      confirm_text:,
      deny_text:,
      primary: false,
      danger: false
    )
      raise ArgumentError, 'buttons may be primary or danger, not both' if primary && danger
      @title =
        if title.is_a?(String)
          SlackBlocks::PlainText.new(text: title)
        elsif title.is_a?(SlackBlocks::PlainText)
          title
        else
          raise ArgumentError, 'must pass a String or SlackBlocks::PlainText object to title keyword argument'
        end
      # Default text to a PlainText object.
      @dialog_text =
        if dialog_text.is_a?(String)
          SlackBlocks::PlainText.new(text: dialog_text)
        elsif dialog_text.is_a?(SlackBlocks::PlainText)
          dialog_text
        elsif dialog_text.is_a?(SlackBlocks::Markdown)
          dialog_text
        else
          raise ArgumentError, 'must pass a String, SlackBlocks::PlainText object or SlackBlocks::Markdown object to dialog_text keyword argument'
        end
      @confirm_text =
        if confirm_text.is_a?(String)
          SlackBlocks::PlainText.new(text: confirm_text)
        elsif confirm_text.is_a?(SlackBlocks::PlainText)
          confirm_text
        else
          raise ArgumentError, 'must pass a String or SlackBlocks::PlainText object to confirm_text keyword argument'
        end
      @deny_text =
        if deny_text.is_a?(String)
          SlackBlocks::PlainText.new(text: deny_text)
        elsif deny_text.is_a?(SlackBlocks::PlainText)
          deny_text
        else
          raise ArgumentError, 'must pass a String or SlackBlocks::PlainText object to deny_text keyword argument'
        end
      @style =
        if primary
          PRIMARY_STYLE
        elsif danger
          DANGER_STYLE
        end
    end

    def as_json
      {
        'title' => @title.as_json,
        'text' => @dialog_text.as_json,
        'confirm' => @confirm_text.as_json,
        'deny' => @deny_text.as_json,
        'style' => @style
      }.compact
    end
  end
end
