# frozen_string_literal: true

require_relative 'slack_blocks/collection'
require_relative 'slack_blocks/context'
require_relative 'slack_blocks/divider'
require_relative 'slack_blocks/header'
require_relative 'slack_blocks/image'
require_relative 'slack_blocks/markdown'
require_relative 'slack_blocks/plain_text'
require_relative 'slack_blocks/version'

module SlackBlocks
  class Error < StandardError; end
  class TooManyElements < Error; end
  class InvalidBlockType < Error; end
end
