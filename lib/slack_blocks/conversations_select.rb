# frozen_string_literal: true

require_relative 'conversation_filter'

# Supports the Conversations Select element, a subset of a Select element.
# This can be used in SlackBlocks::Actions, SlackBlocks::Section and SlackBlocks::Input blocks.
#
# @see https://api.slack.com/reference/block-kit/block-elements#conversation_select
module SlackBlocks
  class ConversationsSelect
    def initialize(
      action_id:,
      placeholder:,
      initial_conversation: nil,
      default_to_current_conversation: false,
      confirm: nil,
      response_url_enabled: false,
      filter: nil,
      focus_on_load: false
    )
      @action_id = action_id
      @placeholder =
        if placeholder.is_a?(String)
          SlackBlocks::PlainText.new(text: placeholder)
        elsif placeholder.is_a?(SlackBlocks::PlainText)
          placeholder
        else
          raise ArgumentError, 'must pass a String or SlackBlocks::PlainText to placeholder keyword argument'
        end
      @initial_conversation = initial_conversation
      @default_to_current_conversation = default_to_current_conversation
      @confirm = confirm
      @response_url_enabled = response_url_enabled
      @filter = filter
      @focus_on_load = focus_on_load
    end

    def as_json
      {
        'type' => 'conversations_select',
        'action_id' => @action_id,
        'placeholder' => @placeholder.as_json,
        'initial_conversation' => @initial_conversation,
        'default_to_current_conversation' => @default_to_current_conversation,
        'confirm' => @confirm&.as_json,
        'response_url_enabled' => @response_url_enabled,
        'filter' => @filter&.as_json,
        'focus_on_load' => @focus_on_load
      }.compact
    end
  end
end
