# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartsController do
  describe 'routes' do
    it 'routes to #show via GET' do
      expect(get: '/cart').to route_to('carts#show')
    end

    it 'routes to #create via POST' do
      expect(post: '/cart').to route_to('carts#create')
    end

    it 'routes to #update via POST' do
      expect(post: '/cart/add_item').to route_to('carts#update')
    end

    it 'routes to #delete via DELETE' do
      expect(delete: '/cart/1').to route_to('carts#delete', product_id: '1')
    end
  end
end
