# frozen_string_literal: true

require_relative 'slack_blocks/concerns/collectable'

require_relative 'slack_blocks/actions'
require_relative 'slack_blocks/button'
require_relative 'slack_blocks/checkboxes'
require_relative 'slack_blocks/collection'
require_relative 'slack_blocks/confirm'
require_relative 'slack_blocks/context'
require_relative 'slack_blocks/date_picker'
require_relative 'slack_blocks/divider'
require_relative 'slack_blocks/external_select'
require_relative 'slack_blocks/file'
require_relative 'slack_blocks/grouped_static_select'
require_relative 'slack_blocks/header'
require_relative 'slack_blocks/image'
require_relative 'slack_blocks/markdown'
require_relative 'slack_blocks/option_group'
require_relative 'slack_blocks/option'
require_relative 'slack_blocks/overflow'
require_relative 'slack_blocks/plain_text'
require_relative 'slack_blocks/radio_buttons'
require_relative 'slack_blocks/time_picker'
require_relative 'slack_blocks/ungrouped_static_select'
require_relative 'slack_blocks/users_select'
require_relative 'slack_blocks/version'

module SlackBlocks
  class Error < StandardError; end
  class TooManyElements < Error; end
  class NotEnoughElements < Error; end
  class InvalidBlockType < Error; end
end
