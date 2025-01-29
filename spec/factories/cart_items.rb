# frozen_string_literal: true

FactoryBot.define do
  factory :cart_item do
    product { nil }
    cart { nil }
    quantity { 0 }
  end
end
