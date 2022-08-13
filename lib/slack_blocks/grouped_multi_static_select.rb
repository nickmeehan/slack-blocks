# frozen_string_literal: true

require_relative 'option_group'

# Supports the grouped version of the Multi Static Select element, a subset of a MultiSelect element.
# This can be used in SlackBlocks::Section and SlackBlocks::Input blocks.
#
# @see https://api.slack.com/reference/block-kit/block-elements#static_multi_select
module SlackBlocks
  class GroupedMultiStaticSelect
    include Collectable

    MINIMUM_MAX_SELECTED_ITEMS = 1

    max_collection_size(100)
    valid_block_klasses(SlackBlocks::OptionGroup)
    collection_instance_variable_name('@option_groups')
    collection_name('option groups')

    def initialize(
      action_id:,
      placeholder:,
      option_groups: [],
      initial_options: nil,
      confirm: nil,
      max_selected_items: nil,
      focus_on_load: false
    )
      unless initial_options.nil?
        raise ArgumentError, 'initial_options must be a collection' unless initial_options.is_a?(Array)
        raise ArgumentError, 'initial_options must contain elements if a collection is to be passed' if initial_options.empty?
        # We skip using the helper here because the initial option is actually a SlackBlocks::Option object, which is
        # nested within SlackBlocks::OptionGroup objects.
        unless initial_options.all? { |option| option.class == SlackBlocks::Option }
          raise SlackBlocks::InvalidBlockType,
            "initial_options must include all SlackBlocks::Option objects within a #{self.class} block"
        end
        # TODO: Come back and make this more performant.
        #       Do we expose and extract the SlackBlocks::OptionGroup#options out and do the comparison against that Set?
        initial_options.each do |initial_option|
          unless option_groups.any? { |option_group| option_group.contains_option?(initial_option) }
            raise ArgumentError, 'please ensure all initial_options passed are included in one of the options collections present within the option_groups collection'
          end
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
      @option_groups = option_groups
      validate_collection_size
      validate_collection_contents
      @initial_options = initial_options
      @confirm = confirm
      @max_selected_items = max_selected_items
      validate_max_selected_items_minimum
      @focus_on_load = focus_on_load
    end

    def as_json
      {
        'type' => 'multi_static_select',
        'action_id' => @action_id,
        'placeholder' => @placeholder.as_json,
        'option_groups' => @option_groups.map(&:as_json),
        'initial_options' => @initial_options&.map(&:as_json),
        'confirm' => @confirm&.as_json,
        'max_selected_items' => @max_selected_items,
        'focus_on_load' => @focus_on_load
      }.compact
    end

    private

    def validate_max_selected_items_minimum
      return if @max_selected_items.nil?
      if @max_selected_items < MINIMUM_MAX_SELECTED_ITEMS
        raise ArgumentError, "the minimum number for max_selected_items if passed is #{MINIMUM_MAX_SELECTED_ITEMS}"
      end
    end
  end
end
