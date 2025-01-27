# frozen_string_literal: true

FactoryBot.define do
  factory :shopping_cart, class: Cart do
    total_price { 10.00 }
    abandoned? { false }
    last_interaction_at { Time.zone.now }
  end
end
