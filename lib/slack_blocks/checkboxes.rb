# frozen_string_literal: true

require_relative 'option'

# Supports the Checkboxes element.
# This can be used in SlackBlocks::Actions, SlackBlocks::Section and SlackBlocks::Input blocks.
#
# @see https://api.slack.com/reference/block-kit/block-elements#checkboxes
module SlackBlocks
  class Checkboxes
    include Collectable

    max_collection_size(10)
    valid_block_klasses(SlackBlocks::Option)
    collection_instance_variable_name('@options')

    def initialize(
      action_id:,
      options: [],
      initial_options: [],
      confirm: nil,
      focus_on_load: false
    )
      # TODO: Change these into helpers, or adapt the current ones for dual purpose use.
      if options.size > max_collection_size
        raise SlackBlocks::TooManyElements, "the maximum number of options for a Checkboxes block is #{max_collection_size}"
      end
      options.each do |element_block|
        validate_incoming_klass(element_block.class)
      end
      remaining_initial_options = initial_options - options
      if remaining_initial_options.any?
        raise ArgumentError, 'please ensure any initial_options passed are included in the options collection'
      end
      @action_id = action_id
      @options = options
      @initial_options = initial_options
      @confirm = confirm
      @focus_on_load = focus_on_load
    end

    def as_json
      {
        'type' => 'checkboxes',
        'action_id' => @action_id,
        'options' => @options.map(&:as_json),
        'initial_options' => @initial_options.map(&:as_json),
        'confirm' => @confirm&.as_json,
        'focus_on_load' => @focus_on_load
      }.compact
    end
  end
end
