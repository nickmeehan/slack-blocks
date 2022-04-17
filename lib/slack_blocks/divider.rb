# frozen_string_literal: true

module SlackBlocks
  class Divider
    def as_json
      {
        'type' => 'divider'
      }
    end
  end
end
