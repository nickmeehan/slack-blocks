# frozen_string_literal: true

require 'json'

require_relative 'context'
require_relative 'divider'
require_relative 'file'
require_relative 'header'
require_relative 'image'

module SlackBlocks
  class Collection
    MAX_ELEMENTS_SIZE = 50
    # TODO: Figure out why files aren't supported, and either remove support for it, or just leave it.
    VALID_BLOCK_KLASSES = [
      # actions,
      # conditions,
      SlackBlocks::Context,
      SlackBlocks::Divider,
      # SlackBlocks::File,
      SlackBlocks::Image,
      # section,
      SlackBlocks::Header,
      # table,
      # contact_card,
      # share_shortcut,
      # share_workflow,
      # video
    ].to_set

    # Cache this so we don't ever have to compute this on the fly.
    VALID_BLOCK_KLASS_STRINGS = VALID_BLOCK_KLASSES.join(', ')

    def initialize
      @blocks = []
    end

    def <<(incoming_block)
      validate_block_klass(incoming_block)
      validate_block_addition
      @blocks << incoming_block
    end

    def as_json
      @blocks.map(&:as_json)
    end

    def to_json
      JSON.unparse(as_json)
    end

    private

    def validate_block_klass(incoming_block)
      # We check the incoming block's class to ensure it's valid.
      unless VALID_BLOCK_KLASSES.include?(incoming_block.class)
        raise SlackBlocks::InvalidBlockType,
          "#{incoming_block.class} is not a valid top-level block type, valid block types are #{VALID_BLOCK_KLASS_STRINGS}"
      end
    end

    def validate_block_addition
      # We check the current size to see if the @blocks array can fits anymore.
      if @blocks.size >= MAX_ELEMENTS_SIZE
        raise SlackBlocks::TooManyElements, "the maximum number of blocks to send at one time is #{MAX_ELEMENTS_SIZE}"
      end
    end
  end
end
