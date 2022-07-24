# frozen_string_literal: true

require 'json'

require_relative 'actions'
require_relative 'context'
require_relative 'divider'
require_relative 'file'
require_relative 'header'
require_relative 'image'
require_relative 'section'

module SlackBlocks
  class Collection
    include Collectable

    max_collection_size(50)
    # TODO: Figure out why files aren't supported, and either remove support for it, or just leave it.
    valid_block_klasses(
      SlackBlocks::Actions,
      # conditions,
      SlackBlocks::Context,
      SlackBlocks::Divider,
      # SlackBlocks::File,
      SlackBlocks::Header,
      SlackBlocks::Image,
      SlackBlocks::Section,
      # table,
      # contact_card,
      # share_shortcut,
      # share_workflow,
      # video
    )

    collection_instance_variable_name('@blocks')
    collection_name('blocks')

    def initialize
      @blocks = []
    end

    def as_json
      @blocks.map(&:as_json)
    end

    def to_json
      JSON.unparse(as_json)
    end
  end
end
