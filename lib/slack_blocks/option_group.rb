# frozen_string_literal: true

require_relative 'option'

# Supports the OptionGroup composition object.
#
# @see https://api.slack.com/reference/block-kit/composition-objects#option_group
module SlackBlocks
  class OptionGroup
    include Collectable

    max_collection_size(100)
    valid_block_klasses(SlackBlocks::Option)
    collection_instance_variable_name('@options')
    collection_name('options')

    def initialize(label:, options: [])
      @label =
        if label.is_a?(String)
          SlackBlocks::PlainText.new(text: label)
        elsif label.is_a?(SlackBlocks::PlainText)
          label
        else
          raise ArgumentError, 'must pass a String or SlackBlocks::PlainText to label keyword argument'
        end
      @options = options
      validate_collection_size
      validate_collection_contents
    end

    def contains_option?(option)
      @options.to_set.include?(option)
    end

    def as_json
      {
        'label' => @label.as_json,
        'options' => @options.map(&:as_json)
      }.compact
    end
  end
end
