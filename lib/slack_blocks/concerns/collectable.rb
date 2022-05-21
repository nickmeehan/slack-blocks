# frozen_string_literal: true

require "active_support/concern"

module Collectable
  extend ActiveSupport::Concern

  class_methods do
    # The classes the collection can accept.
    def valid_block_klasses(*klasses)
      return @valid_block_klasses if klasses.empty?
      @valid_block_klasses = klasses.to_set
    end

    # Cache this so we don't ever have to compute this on the fly.
    def valid_block_klass_strings
      @valid_block_klass_strings ||= @valid_block_klasses.join(', ')
    end

    # The max number of elements the collection can support.
    def max_collection_size(size = nil)
      return @max_collection_size if size.nil?
      @max_collection_size = size
    end

    # The max number of elements the collection can support.
    def min_collection_size(size = nil)
      return @min_collection_size if size.nil?
      @min_collection_size = size
    end

    # The name of the primary collection for a block.
    def collection_instance_variable_name(variable_name = nil)
      return @collection_instance_variable_name if variable_name.nil?
      @collection_instance_variable_name = variable_name
    end
  end

  def <<(incoming_element)
    validate_incoming_klass(incoming_element.class)
    validate_collection_addition
    collection_instance_variable << incoming_element
  end

  private

  # There should only ever be one collection set.
  def collection_instance_variable
    self.instance_variable_get(self.class.collection_instance_variable_name)
  end

  def validate_incoming_klass(klass)
    # We check the incoming element block's class to ensure it's valid.
    unless self.class.valid_block_klasses.include?(klass)
      raise SlackBlocks::InvalidBlockType,
        "#{klass} is not valid to be used in a #{self.class} block, valid block types are #{self.class.valid_block_klass_strings}"
    end
  end

  def validate_collection_contents
    collection_instance_variable.each do |element_block|
      validate_incoming_klass(element_block.class)
    end
  end

  # We should only use this validation upon setting the collection in an initializer.
  def validate_collection_size
    # The collection is valid here.
    return if collection_instance_variable.size <= max_collection_size

    # Otherwise, inform the user the collection has too many elements.
    raise SlackBlocks::TooManyElements, "the maximum number of elements for a #{self.class} block is #{max_collection_size}"
  end

  # We look to validate the size of the of the collection as less than the max ONLY when attempting to add more elements.
  def validate_collection_addition
    # We check the current size to see if the collection can fit anymore.
    return if collection_instance_variable.size < max_collection_size

    # Otherwise, we disallow the addition of the block.
    raise SlackBlocks::TooManyElements, "the maximum number of elements for a #{self.class} block is #{max_collection_size}"
  end

  def validate_minimum_blocks
    # We check the current size to see if the number of elements requires the minimum threshold for rendering.
    if collection_instance_variable.size < min_collection_size
      raise SlackBlocks::NotEnoughElements, "the minimum number of elements for a #{self.class} block is #{min_collection_size}"
    end
  end

  def max_collection_size
    self.class.max_collection_size
  end

  def min_collection_size
    self.class.min_collection_size
  end
end
