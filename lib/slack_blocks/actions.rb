# frozen_string_literal: true

require_relative 'button'
require_relative 'checkboxes'
require_relative 'date_picker'
require_relative 'overflow'
require_relative 'radio_buttons'
require_relative 'time_picker'
require_relative 'ungrouped_static_select'

# Supports the Actions object.
#
# @see https://api.slack.com/reference/block-kit/blocks#actions
module SlackBlocks
  class Actions
    include Collectable

    max_collection_size(25)
    valid_block_klasses(
      SlackBlocks::Button,
      SlackBlocks::Checkboxes,
      SlackBlocks::DatePicker,
      SlackBlocks::Overflow,
      SlackBlocks::RadioButtons,
      SlackBlocks::TimePicker,
      SlackBlocks::UngroupedStaticSelect
    )
    collection_instance_variable_name('@elements')

    def initialize(elements: [])
      # TODO: Change these into helpers, or adapt the current ones for dual purpose use.
      if elements.size > max_collection_size
        raise SlackBlocks::TooManyElements, "the maximum number of elements for an Actions block is #{max_collection_size}"
      end
      elements.each do |element_block|
        validate_incoming_klass(element_block.class)
      end
      @elements = elements
    end

    def as_json
      {
        'type' => 'actions',
        'elements' => @elements.map(&:as_json)
      }
    end
  end
end
