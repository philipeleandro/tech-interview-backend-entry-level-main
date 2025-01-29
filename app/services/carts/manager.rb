# frozen_string_literal: true

module Carts
  class Manager
    def call!
      carts.each do |cart|
        cart_flow(cart)
      end
    end

    private

    def carts
      @carts ||= Cart.all
    end

    def cart_flow(cart)
      ActiveRecord::Base.transaction do
        cart.mark_as_abandoned
        cart.remove_if_abandoned
      rescue Exception
        raise ActiveRecord::Rollback
      end
    end
  end
end
