# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Carts::Presenter do
  subject(:result) { instance.call!.with_indifferent_access }

  let(:instance) { described_class.new(cart.id) }
  let(:cart) { create(:shopping_cart) }
  let(:product) { create(:product) }
  let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

  context 'when success' do
    it { expect(result).to have_key(:id) }
    it { expect(result).to have_key(:products) }
    it { expect(result).to have_key(:total_price) }
  end

  context 'when fail' do
    before do
      allow(Cart).to receive(:find_by).and_raise(StandardError, 'Test error')
    end

    it { expect(result).to eq({ 'error' => 'Test error' }) }
  end
end
