# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Carts::Destroyer do
  subject(:result) { instance.call! }

  let(:instance) { described_class.new(product.id, cart.id) }
  let(:cart) { create(:shopping_cart) }
  let(:product) { create(:product) }
  let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

  context 'when success' do
    it { expect { result }.not_to change(Product, :count) }
    it { expect { result }.not_to change(Cart, :count) }
    it { expect { result }.to change(CartItem, :count).by(-1) }
  end

  context 'when fail' do
    before do
      allow(Cart).to receive(:find_by).and_raise(StandardError, 'Test error')
    end

    it { expect(result).to eq({ error: 'Test error' }) }
  end
end
