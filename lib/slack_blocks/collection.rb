# frozen_string_literal: true

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
  end
end
