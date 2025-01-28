# frozen_string_literal: true

FactoryBot.define do
  factory :cart_item do
    product { nil }
    e { 'MyString' }
    cart { nil }
  end
end
