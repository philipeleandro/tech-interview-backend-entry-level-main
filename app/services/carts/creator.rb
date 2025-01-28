# frozen_string_literal: true

module Carts
  class Creator
    def initialize(params)
      @cart_id = params[:cart_id]
      @product_id = params[:product_id]
      @quantity = params[:quantity]
    end

    def call!
      ActiveRecord::Base.transaction do
        create_or_update_cart_item
        update_cart!
      end

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

    def create_or_update_cart_item
      cart_item = cart_item(@product_id)

      return cart_item.update!(quantity: (cart_item.quantity + @quantity)) if cart_item

      CartItem.create!(cart_id: cart.id, product_id: @product_id, quantity: @quantity)
    end

    def cart
      @cart ||= @cart_id.present? ? Cart.find(@cart_id) : Cart.create(total_price: 0)
    end

    def product
      Product.find(@product_id)
    end

    def update_cart!
      cart.update!(total_price: price_total, last_interaction_at: Time.zone.now)
    end

    def cart_item(product_id)
      cart.cart_items.where(product_id: product_id).first
    end

    def price_total
      cart.reload.total_price += (product.price * @quantity)
    end

    def product_ids
      cart.cart_items.pluck(:product_id).uniq
    end

    def products
      products_data = Product.select(:id, :name, :price).where(id: product_ids)

      products_data.map do |product|
        product_to_json = JSON.parse(product.to_json)

        product_to_json.merge!(quantity: quantity_products(product.id),
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
