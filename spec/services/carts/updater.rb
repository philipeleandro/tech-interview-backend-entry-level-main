# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Carts::Updater do
  subject(:result) { instance.call! }

  let(:instance) { described_class.new(params) }
  let(:params) { { cart_id: cart.id, product_id: product.id, quantity: 2 } }
  let(:cart) { create(:shopping_cart) }
  let(:product) { create(:product) }
  let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

  context 'when success' do
    before { result }

    it { expect(cart_item.reload.quantity).to eq(2) }
  end

  context 'when fail' do
    before do
      allow(Cart).to receive(:find_by).and_raise(StandardError, 'Test error')
    end

    it { expect(result).to eq({ error: 'Test error' }) }
  end
end
