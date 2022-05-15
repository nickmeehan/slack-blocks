# frozen_string_literal: true

# Supports the TimePicker element.
# This can be used in SlackBlocks::Actions, SlackBlocks::Section and SlackBlocks::Input blocks.
#
# @see https://api.slack.com/reference/block-kit/block-elements#timepicker
module SlackBlocks
  class TimePicker
    # The necessary format according to Slack.
    TIME_FORMAT = /^([01][0-9]|2[0-3]):[0-5][0-9]$/

    def initialize(
      action_id:,
      placeholder: nil,
      initial_time: nil,
      confirm: nil,
      focus_on_load: false
    )
      unless initial_time.nil?
        raise ArgumentError, 'initial_time format must be HH:mm' unless initial_time.match?(TIME_FORMAT)
      end
      @action_id = action_id
      @placeholder =
        if placeholder.is_a?(String)
          SlackBlocks::PlainText.new(text: placeholder)
        elsif placeholder.is_a?(SlackBlocks::PlainText)
          placeholder
        else
          placeholder
        end
      @initial_time = initial_time
      @confirm = confirm
      @focus_on_load = focus_on_load
    end

    def as_json
      {
        'type' => 'timepicker',
        'action_id' => @action_id,
        'placeholder' => @placeholder&.as_json,
        'initial_time' => @initial_time,
        'confirm' => @confirm&.as_json,
        'focus_on_load' => @focus_on_load
      }.compact
    end
  end
end
