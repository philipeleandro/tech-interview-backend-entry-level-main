# frozen_string_literal: true

module Carts
  class Presenter
    def initialize(cart_id)
      @cart_id = cart_id
    end

    def call!
      return_data
    rescue StandardError => e
      { error: e.message }
    end

    private

    def return_data
      return { message: 'Cart not found' } if cart.nil?

      { id: cart.id,
        products: products,
        total_price: cart.total_price }
    end

    def cart
      @cart ||= Cart.find_by(id: @cart_id)
    end

    def products
      cart_items = cart.cart_items

      return [] if cart_items.empty?

      cart_items.map do |cart_item|
        product = cart_item.product
        product_to_json = JSON.parse(product.to_json).symbolize_keys
        parsed_data = product_to_json.except!(:created_at, :updated_at)

        parsed_data.merge!(quantity: quantity_products(product.id),
                           total_price: products_total_price(product.price, product.id))
      end
    end

    def quantity_products(product_id)
      cart_item = cart.cart_items.where(product_id: product_id).first

      cart_item.try(:quantity)
    end

    def products_total_price(value, product_id)
      quantity_products(product_id) * value
    end
  end
end
