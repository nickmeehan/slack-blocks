# frozen_string_literal: true

require 'json'

module SlackBlocks
  class Collection
    def initialize
      @blocks = []
    end

    # TODO: Add in some validation on whether this collection can handle
    # the max number of blocks.
    def <<(block)
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
