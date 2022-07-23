# frozen_string_literal: true

require_relative 'conversation_filter'

# Supports the Public Channels Select element, a subset of a Select element.
# This can be used in SlackBlocks::Actions, SlackBlocks::Section and SlackBlocks::Input blocks.
#
# @see https://api.slack.com/reference/block-kit/block-elements#channel_select
module SlackBlocks
  class ChannelsSelect
    def initialize(
      action_id:,
      placeholder:,
      initial_channel: nil,
      confirm: nil,
      response_url_enabled: false,
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
      @initial_channel = initial_channel
      @confirm = confirm
      @response_url_enabled = response_url_enabled
      @focus_on_load = focus_on_load
    end

    def as_json
      {
        'type' => 'channels_select',
        'action_id' => @action_id,
        'placeholder' => @placeholder.as_json,
        'initial_channel' => @initial_channel,
        'confirm' => @confirm&.as_json,
        'response_url_enabled' => @response_url_enabled,
        'focus_on_load' => @focus_on_load
      }.compact
    end
  end
end
