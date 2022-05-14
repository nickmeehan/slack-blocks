# frozen_string_literal: true

# Supports the File object.
#
# @see https://api.slack.com/reference/block-kit/blocks#file
module SlackBlocks
  class File
    # TODO: Add in block_id as an argument.
    def initialize(external_id:)
      @external_id = external_id
    end

    def as_json
      {
        'type' => 'file',
        'source' => 'remote',
        'external_id' => @external_id
      }
    end
  end
end
