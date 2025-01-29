# frozen_string_literal: true

module Carts
  class Updater
    def initialize(params)
      @cart_id = params[:cart_id]
      @quantity = params[:quantity]
      @product_id = params[:product_id]
    end

    def call!
      update_product_quantity
      update_total_price_cart
      return_data
    rescue StandardError => e
      { error: e.message }
    end

    private

    def update_product_quantity
      raise StandardError, 'Product not found' if cart_item_by_product.nil?

      cart_item_by_product.update(quantity: @quantity)
    end

    def return_data
      return { message: 'Cart not found' } if cart.nil?

      { id: cart.id,
        products: products,
        total_price: cart.total_price }
    end

    def cart_item_by_product
      cart_items.where(product_id: @product_id).first
    end

    def update_total_price_cart
      cart.update!(total_price: cart_total_price_array.sum, last_interaction_at: Time.zone.now)
    end

    def cart_total_price_array
      cart_items.map { |cart_item| cart_item.quantity * cart_item.product.price }
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
