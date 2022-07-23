# frozen_string_literal: true

require_relative 'option'

# Supports the External Data Source Select element, a subset of a Select element.
# This can be used in SlackBlocks::Actions, SlackBlocks::Section and SlackBlocks::Input blocks.
#
# @see https://api.slack.com/reference/block-kit/block-elements#external_select
module SlackBlocks
  class ExternalSelect
    def initialize(
      action_id:,
      placeholder:,
      initial_option: nil,
      min_query_length: nil,
      confirm: nil,
      focus_on_load: false
    )
      # We know the initial option here will always need to be SlackBlocks::Option unless nil.
      if !initial_option.nil? && initial_option.class != SlackBlocks::Option
        raise SlackBlocks::InvalidBlockType,
          "#{initial_option.class} is not valid to be used in a #{self.class} block, you must use SlackBlocks::Option"
      end
      @action_id = action_id
      @placeholder =
        if placeholder.is_a?(String)
          SlackBlocks::PlainText.new(text: placeholder)
        elsif placeholder.is_a?(SlackBlocks::PlainText)
          placeholder
        else
          raise ArgumentError, 'must pass a String or SlackBlocks::PlainText to placeholder keyword argument'
        end
      @initial_option = initial_option
      @min_query_length = min_query_length
      @confirm = confirm
      @focus_on_load = focus_on_load
    end

    def as_json
      {
        'type' => 'external_select',
        'action_id' => @action_id,
        'placeholder' => @placeholder.as_json,
        'initial_option' => @initial_option&.as_json,
        'min_query_length' => @min_query_length,
        'confirm' => @confirm&.as_json,
        'focus_on_load' => @focus_on_load
      }.compact
    end
  end
end
