# frozen_string_literal: true

require_relative 'option'

# Supports the ungrouped version of the Static Select element, a subset of a Select element.
# This can be used in SlackBlocks::Actions, SlackBlocks::Section and SlackBlocks::Input blocks.
#
# @see https://api.slack.com/reference/block-kit/block-elements#static_select
module SlackBlocks
  class UngroupedStaticSelect
    include Collectable

    max_collection_size(100)
    valid_block_klasses(SlackBlocks::Option)
    collection_instance_variable_name('@options')
    collection_name('options')

    def initialize(
      action_id:,
      placeholder:,
      options: [],
      initial_option: nil,
      confirm: nil,
      focus_on_load: false
    )
      unless initial_option.nil?
        validate_incoming_klass(initial_option.class)
        unless options.include?(initial_option)
          raise ArgumentError, 'please ensure the initial_option passed is included in the options collection'
        end
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
      @options = options
      validate_collection_size
      validate_collection_contents
      @initial_option = initial_option
      @confirm = confirm
      @focus_on_load = focus_on_load
    end

    def as_json
      {
        'type' => 'static_select',
        'action_id' => @action_id,
        'placeholder' => @placeholder.as_json,
        'options' => @options.map(&:as_json),
        'initial_option' => @initial_option&.as_json,
        'confirm' => @confirm&.as_json,
        'focus_on_load' => @focus_on_load
      }.compact
    end
  end
end
