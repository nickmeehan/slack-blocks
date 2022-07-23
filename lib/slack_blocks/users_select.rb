# frozen_string_literal: true

require_relative 'option'

# Supports the Users Select element, a subset of a Select element.
# This can be used in SlackBlocks::Actions, SlackBlocks::Section and SlackBlocks::Input blocks.
#
# @see https://api.slack.com/reference/block-kit/block-elements#users_select
module SlackBlocks
  class UsersSelect
    def initialize(
      action_id:,
      placeholder:,
      initial_user: nil,
      confirm: nil,
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
      @initial_user = initial_user
      @confirm = confirm
      @focus_on_load = focus_on_load
    end

    def as_json
      {
        'type' => 'users_select',
        'action_id' => @action_id,
        'placeholder' => @placeholder.as_json,
        'initial_user' => @initial_user,
        'confirm' => @confirm&.as_json,
        'focus_on_load' => @focus_on_load
      }.compact
    end
  end
end
