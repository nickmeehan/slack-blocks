# frozen_string_literal: true

require "active_support/concern"

module Collectable
  include ActiveSupport::Concern

  def behaviour
    puts 'OK'
  end
end
