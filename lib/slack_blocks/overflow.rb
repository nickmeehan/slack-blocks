# frozen_string_literal: true

require_relative 'option'

# Supports the Overflow element.
# This can be used in SlackBlocks::Actions and SlackBlocks::Section blocks.
#
# @see https://api.slack.com/reference/block-kit/block-elements#overflow
module SlackBlocks
  class Overflow
    include Collectable

    min_collection_size(2)
    max_collection_size(5)
    valid_block_klasses(SlackBlocks::Option)
    collection_instance_variable_name('@options')

    def initialize(
      action_id:,
      options: [],
      confirm: nil
    )
      # TODO: Change these into helpers, or adapt the current ones for dual purpose use.
      if options.size > max_collection_size
        raise SlackBlocks::TooManyElements, "the maximum number of options for an Overflow block is #{max_collection_size}"
      end
      options.each do |element_block|
        validate_incoming_klass(element_block.class)
      end
      @action_id = action_id
      @options = options
      @confirm = confirm
    end

    def as_json
      validate_minimum_blocks
      {
        'type' => 'overflow',
        'action_id' => @action_id,
        'options' => @options.map(&:as_json),
        'confirm' => @confirm&.as_json
      }.compact
    end
  end
end
