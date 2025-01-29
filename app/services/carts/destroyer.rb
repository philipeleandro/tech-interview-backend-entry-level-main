# frozen_string_literal: true

module Carts
  class Destroyer
    def initialize(product_id, cart_id)
      @product_id = product_id
      @cart_id = cart_id
    end

    def call!
      return { error: 'Product not found in the cart' } if product.nil?

      delete_product_from_cart
      update_total_price_cart
      return_data
    rescue StandardError => e
      { error: e.message }
    end

    private

    def return_data
      { id: cart.id,
        products: products,
        total_price: cart.total_price }
    end

    def update_total_price_cart
      cart.update!(total_price: cart_total_price_array.sum, last_interaction_at: Time.zone.now)
    end

    def cart_total_price_array
      cart_items.map { |cart_item| cart_item.quantity * cart_item.product.price }
    end

    def product
      @product ||= cart.cart_items.where(product_id: @product_id).first
    end

    def delete_product_from_cart
      product.try!(:delete)
    end

    def cart
      @cart ||= Cart.find_by(id: @cart_id)
    end

    def cart_items
      cart.cart_items
    end

    def products
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
      cart_item = cart_items.where(product_id: product_id).first

      cart_item.try(:quantity)
    end

    def products_total_price(value, product_id)
      quantity_products(product_id) * value
    end
  end
end
