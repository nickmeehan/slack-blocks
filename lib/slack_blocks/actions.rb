# frozen_string_literal: true

require_relative 'button'
require_relative 'checkboxes'
require_relative 'conversations_select'
require_relative 'date_picker'
require_relative 'external_select'
require_relative 'grouped_static_select'
require_relative 'overflow'
require_relative 'radio_buttons'
require_relative 'time_picker'
require_relative 'ungrouped_static_select'
require_relative 'users_select'

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
      SlackBlocks::ConversationsSelect,
      SlackBlocks::DatePicker,
      SlackBlocks::ExternalSelect,
      SlackBlocks::GroupedStaticSelect,
      SlackBlocks::Overflow,
      SlackBlocks::RadioButtons,
      SlackBlocks::TimePicker,
      SlackBlocks::UngroupedStaticSelect,
      SlackBlocks::UsersSelect
    )
    collection_instance_variable_name('@elements')

    def initialize(elements: [])
      @elements = elements
      validate_collection_size
      validate_collection_contents
    end

    def as_json
      {
        'type' => 'actions',
        'elements' => @elements.map(&:as_json)
      }
    end
  end
end
