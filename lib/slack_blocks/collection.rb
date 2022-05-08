# frozen_string_literal: true

require 'json'

module SlackBlocks
  class Collection
    MAX_ELEMENTS_SIZE = 50

    def initialize
      @blocks = []
    end

    def <<(block)
      # We check the current size to see if the @blocks array can fits anymore.
      if @blocks.size >= MAX_ELEMENTS_SIZE
        raise SlackBlocks::TooManyElements, "the maximum number of blocks to send at one time is #{MAX_ELEMENTS_SIZE}"
      end
      @blocks << block
    end

    def as_json
      @blocks.map(&:as_json)
    end

    def to_json
      JSON.unparse(as_json)
    end
  end
end
