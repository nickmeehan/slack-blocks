# frozen_string_literal: true

require_relative 'option'

# Supports the ungrouped version of the Multi Static Select element, a subset of a MultiSelect element.
# This can be used in SlackBlocks::Section and SlackBlocks::Input blocks.
#
# @see https://api.slack.com/reference/block-kit/block-elements#static_multi_select
module SlackBlocks
  class UngroupedMultiStaticSelect
    include Collectable

    MINIMUM_MAX_SELECTED_ITEMS = 1

    max_collection_size(100)
    valid_block_klasses(SlackBlocks::Option)
    collection_instance_variable_name('@options')
    collection_name('options')

    def initialize(
      action_id:,
      placeholder:,
      options: [],
      initial_options: nil,
      confirm: nil,
      max_selected_items: nil,
      focus_on_load: false
    )
      unless initial_options.nil?
        raise ArgumentError, 'initial_options must be a collection' unless initial_options.is_a?(Array)
        raise ArgumentError, 'initial_options must contain elements if a collection is to be passed' if initial_options.empty?
        options_set = options.to_set
        # We loop through all initial_options here because we need to do this validation work on a per option basis
        # anyways.
        initial_options.each do |initial_option|
          # We want to ensure the initial_options are the same as our Collectable collection, SlackBlocks::Option.
          validate_incoming_klass(initial_option.class)
          # And since we are already iterating through the
          unless options_set.include?(initial_option)
            raise ArgumentError, 'please ensure all initial_options passed are included in the options collection'
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
      @options = options
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
        'options' => @options.map(&:as_json),
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
