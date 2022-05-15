# frozen_string_literal: true

require 'date'

# Supports the DatePicker element.
# This can be used in SlackBlocks::Actions, SlackBlocks::Section and SlackBlocks::Input blocks.
#
# @see https://api.slack.com/reference/block-kit/block-elements#datepicker
module SlackBlocks
  class DatePicker
    # The necessary format according to Slack.
    INITIAL_DATE_STRF_FORMAT = '%Y-%m-%d'

    def initialize(
      action_id:,
      placeholder: nil,
      initial_date: nil,
      confirm: nil,
      focus_on_load: false
    )
      unless initial_date.nil?
        begin
          Date.strptime(initial_date, INITIAL_DATE_STRF_FORMAT)
        rescue Date::Error
          raise ArgumentError, 'initial_date format must be in YYYY-MM-DD'
        end
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
      @initial_date = initial_date
      @confirm = confirm
      @focus_on_load = focus_on_load
    end

    def as_json
      {
        'type' => 'datepicker',
        'action_id' => @action_id,
        'placeholder' => @placeholder&.as_json,
        'initial_date' => @initial_date,
        'confirm' => @confirm&.as_json,
        'focus_on_load' => @focus_on_load
      }.compact
    end
  end
end
