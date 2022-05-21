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

    def initialize(
      action_id:,
      placeholder:,
      options: [],
      initial_option: nil,
      confirm: nil,
      focus_on_load: false
    )
      # TODO: Change these into helpers, or adapt the current ones for dual purpose use.
      if options.size > max_collection_size
        raise SlackBlocks::TooManyElements, "the maximum number of options for a Static Select block is #{max_collection_size}"
      end
      options.each do |element_block|
        validate_incoming_klass(element_block.class)
      end
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
          fail ArgumentError, 'must pass a String or SlackBlocks::PlainText to placeholder keyword argument'
        end
      @options = options
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
