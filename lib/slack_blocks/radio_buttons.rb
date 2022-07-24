# frozen_string_literal: true

require_relative 'option'

# Supports the Radio Buttons element.
# This can be used in SlackBlocks::Actions, SlackBlocks::Section and SlackBlocks::Input blocks.
#
# @see https://api.slack.com/reference/block-kit/block-elements#radio
module SlackBlocks
  class RadioButtons
    include Collectable

    max_collection_size(10)
    valid_block_klasses(SlackBlocks::Option)
    collection_instance_variable_name('@options')
    collection_name('options')

    def initialize(
      action_id:,
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
      @options = options
      validate_collection_size
      validate_collection_contents
      @initial_option = initial_option
      @confirm = confirm
      @focus_on_load = focus_on_load
    end

    def as_json
      {
        'type' => 'radio_buttons',
        'action_id' => @action_id,
        'options' => @options.map(&:as_json),
        'initial_option' => @initial_option&.as_json,
        'confirm' => @confirm&.as_json,
        'focus_on_load' => @focus_on_load
      }.compact
    end
  end
end
