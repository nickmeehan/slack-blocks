# frozen_string_literal: true

# Require accessory blocks.
require_relative 'button'
require_relative 'channels_select'
require_relative 'checkboxes'
require_relative 'conversations_select'
require_relative 'date_picker'
require_relative 'external_select'
require_relative 'grouped_multi_static_select'
require_relative 'grouped_static_select'
require_relative 'image'
require_relative 'overflow'
require_relative 'radio_buttons'
require_relative 'time_picker'
require_relative 'ungrouped_multi_static_select'
require_relative 'ungrouped_static_select'
require_relative 'users_select'

# Require text blocks.
require_relative 'markdown'
require_relative 'plain_text'

# Supports the Section block object.
#
# @see https://api.slack.com/reference/block-kit/blocks#section
module SlackBlocks
  class Section
    include Collectable

    min_collection_size(1)
    max_collection_size(10)
    valid_block_klasses(
      SlackBlocks::Markdown,
      SlackBlocks::PlainText
    )
    collection_instance_variable_name('@fields')
    collection_name('fields')

    VALID_ACCESSORY_KLASSES = Set.new([
      SlackBlocks::Button,
      SlackBlocks::ChannelsSelect,
      SlackBlocks::Checkboxes,
      SlackBlocks::ConversationsSelect,
      SlackBlocks::DatePicker,
      SlackBlocks::ExternalSelect,
      SlackBlocks::GroupedMultiStaticSelect,
      SlackBlocks::GroupedStaticSelect,
      SlackBlocks::Overflow,
      SlackBlocks::RadioButtons,
      SlackBlocks::TimePicker,
      SlackBlocks::UngroupedMultiStaticSelect,
      SlackBlocks::UngroupedStaticSelect,
      SlackBlocks::UsersSelect
    ]).freeze

    def initialize(text: nil, fields: nil, accessory: nil)

      @text =
        if text.is_a?(String)
          SlackBlocks::PlainText.new(text: text)
        elsif text.is_a?(SlackBlocks::PlainText) || text.is_a?(SlackBlocks::Markdown) || text.nil?
          text
        else
          raise ArgumentError,
            'must pass nil, a String, SlackBlocks::PlainText object or SlackBlocks::Markdown object to text keyword argument'
        end
      @fields = fields
      # We set a default here because we are guarding against @text and @fields being nil, which is a possible case. If
      # this happens, we fall back on @fields, as per the Section documentation (linked above).
      @fields ||= [] if @text.nil?
      unless @fields.nil?
        validate_collection_size
        validate_collection_contents
      end
      @accessory = accessory
      validate_accessory_klass
    end

    def as_json
      {
        'type' => 'section',
        'text' => @text&.as_json,
        'fields' => @fields&.map(&:as_json),
        'accessory' => @accessory&.as_json
      }.compact
    end

    private

    def validate_accessory_klass
      return if @accessory.nil?
      unless VALID_ACCESSORY_KLASSES.include?(@accessory.class)
        raise SlackBlocks::InvalidBlockType,
          "#{@accessory.class} is not valid to be used in a #{self.class} block, valid accessory block types are #{VALID_ACCESSORY_KLASSES.join(', ')}"
      end
    end
  end
end
