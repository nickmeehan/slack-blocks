# frozen_string_literal: true

require_relative 'option_group'

# Supports the grouped version of the Static Select element, a subset of a Select element.
# This can be used in SlackBlocks::Actions, SlackBlocks::Section and SlackBlocks::Input blocks.
#
# @see https://api.slack.com/reference/block-kit/block-elements#static_select
module SlackBlocks
  class GroupedStaticSelect
    include Collectable

    max_collection_size(100)
    valid_block_klasses(SlackBlocks::OptionGroup)
    collection_instance_variable_name('@option_groups')

    def initialize(
      action_id:,
      placeholder:,
      option_groups: [],
      initial_option: nil,
      confirm: nil,
      focus_on_load: false
    )
      unless initial_option.nil?
        # We skip using the helper here because the initial option is actually a SlackBlocks::Option object, which is
        # nested within SlackBlocks::OptionGroup objects.
        unless initial_option.class == SlackBlocks::Option
          raise SlackBlocks::InvalidBlockType,
            "#{initial_option.class} is not valid to be used in a #{self.class} block, you must use SlackBlocks::Option"
        end
        unless option_groups.any? { |option_group| option_group.contains_option?(initial_option) }
          raise ArgumentError, 'please ensure the initial_option passed is included in one of the options collections present within the option_groups collection'
        end
      end
      @action_id = action_id
      @placeholder =
        if placeholder.is_a?(String)
          SlackBlocks::PlainText.new(text: placeholder)
        elsif placeholder.is_a?(SlackBlocks::PlainText)
          placeholder
        else
          fail ArgumentError, 'must pass a String or SlackBlocks::PlainText to placeholder keyword argument'
        end
      @option_groups = option_groups
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
        'option_groups' => @option_groups.map(&:as_json),
        'initial_option' => @initial_option&.as_json,
        'confirm' => @confirm&.as_json,
        'focus_on_load' => @focus_on_load
      }.compact
    end
  end
end
