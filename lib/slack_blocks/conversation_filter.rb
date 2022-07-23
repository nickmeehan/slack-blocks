# frozen_string_literal: true

# Supports the Filter composition object for Conversations.
#
# @see https://api.slack.com/reference/block-kit/composition-objects#filter_conversations
module SlackBlocks
  class ConversationFilter
    def initialize(
      included: nil,
      exclude_external_shared_channels: false,
      exclude_bot_users: false
    )
      unless included.nil?
        raise ArgumentError, 'included must be an Array of Strings' if !included.is_a?(Array) || included.empty?
      end
      @included = included
      @exclude_external_shared_channels = exclude_external_shared_channels
      @exclude_bot_users = exclude_bot_users
    end

    def as_json
      {
        'include' => @included,
        'exclude_external_shared_channels' => @exclude_external_shared_channels,
        'exclude_bot_users' => @exclude_bot_users
      }.compact
    end
  end
end
