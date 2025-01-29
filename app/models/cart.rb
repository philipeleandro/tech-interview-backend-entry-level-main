# frozen_string_literal: true

class Cart < ApplicationRecord
  has_many :cart_items

  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  def mark_as_abandoned
    return unless last_interaction_at < 3.hour.ago

    update!(abandoned?: true)
  end

  def remove_if_abandoned
    return unless last_interaction_at < 7.days.ago

    destroy
  end
end
