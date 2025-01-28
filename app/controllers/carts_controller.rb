# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :authenticate_devise_api_token!
  def add_item
    result = ::Carts::Creator.new(service_params).call!

    if result[:error]
      render json: { error: result[:error] }, status: :unprocessable_entity
    else
      save_in_redis(current_devise_api_token.access_token, result[:id])

      render json: result, status: :ok
    end
  end

  private

  def service_params
    return permitted_params if recovery_in_redis(current_devise_api_token.access_token).nil?

    permitted_params.merge!(cart_id: recovery_in_redis(current_devise_api_token.access_token))
  end

  def permitted_params
    params.permit(:quantity, :product_id)
  end
end
