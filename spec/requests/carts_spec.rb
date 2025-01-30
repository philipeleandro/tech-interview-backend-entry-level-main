# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/carts' do
  let(:user) { create(:user, email: 'fake@test.com') }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:token) do
    post '/users/tokens/sign_in', params: { email: user.email, password: '123456' }
    JSON.parse(response.body)['token']
  end

  before do
    cart_item

    RedisApp.instance.set(token, cart.id)
  end

  describe 'POST /cart' do
    let(:cart) { Cart.create(total_price: 10) }
    let(:product) { Product.create(name: 'Test Product', price: 10.0) }
    let(:cart_item) { CartItem.create(cart_id: cart.id, product_id: product.id, quantity: 1) }

    context 'when the product already is in the cart' do
      subject do
        post '/cart', headers: headers, params: { product_id: product.id, quantity: 1 }, as: :json
        post '/cart', headers: headers, params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end

    context 'when error' do
      subject(:request) do
        post '/cart', headers: headers, params: { product_id: product.id, quantity: 1 }, as: :json
      end

      before do
        allow_any_instance_of(Carts::Creator).to receive(:call!).and_return({ error: 'Fake Error' })
      end

      it 'return error message' do
        request

        expect(JSON.parse(response.body).symbolize_keys).to eq(error: 'Fake Error')
      end
    end
  end

  describe 'POST /cart/add_item' do
    subject(:request) do
      post '/cart/add_item', headers: headers, params: { product_id: product.id, quantity: 2 },
                             as: :json
    end

    let(:cart) { Cart.create(total_price: 10) }
    let(:product) { Product.create(name: 'Test Product', price: 10.0) }
    let(:cart_item) { CartItem.create(cart_id: cart.id, product_id: product.id, quantity: 1) }

    context 'when updates product quantity' do
      it { expect { subject }.to change { cart_item.reload.quantity }.from(1).to(2) }
    end

    context 'when error' do
      before do
        allow_any_instance_of(Carts::Updater).to receive(:call!).and_return({ error: 'Fake Error' })
      end

      it 'return error message' do
        request

        expect(JSON.parse(response.body).symbolize_keys).to eq(error: 'Fake Error')
      end
    end
  end

  describe 'GET /cart' do
    subject(:request) { get '/cart', headers: headers }

    let(:cart) { Cart.create(total_price: 10) }
    let(:product) { Product.create(name: 'Test Product', price: 10.0) }
    let(:cart_item) { CartItem.create(cart_id: cart.id, product_id: product.id, quantity: 1) }

    context 'when returns cart' do
      it 'returns the cart with products' do
        request

        expect(JSON.parse(response.body)).to have_key('products')
        expect(JSON.parse(response.body)).to have_key('id')
        expect(JSON.parse(response.body)).to have_key('total_price')
      end
    end

    context 'when error' do
      before do
        allow_any_instance_of(Carts::Presenter).to receive(:call!).and_return({ error: 'Fake Error' })
      end

      it 'return error message' do
        request

        expect(JSON.parse(response.body).symbolize_keys).to eq(error: 'Fake Error')
      end
    end
  end

  describe 'DELETE /cart/:product_id' do
    subject(:request) do
      delete "/cart/#{product.id}", headers: headers
    end

    let(:cart) { Cart.create(total_price: 10) }
    let(:product) { Product.create(name: 'Test Product', price: 10.0) }
    let(:cart_item) { CartItem.create(cart_id: cart.id, product_id: product.id, quantity: 1) }

    context 'when deletes product' do
      it { expect { request }.to change { cart.cart_items.count }.from(1).to(0) }
    end

    context 'when error' do
      before do
        allow_any_instance_of(Carts::Destroyer).to receive(:call!).and_return({ error: 'Fake Error' })
      end

      it 'return error message' do
        request

        expect(JSON.parse(response.body).symbolize_keys).to eq(error: 'Fake Error')
      end
    end
  end
end
