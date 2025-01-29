# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Carts::Creator do
  subject(:result) { instance.call! }

  let(:instance) { described_class.new(params) }
  let(:params) { { quantity: 1, product_id: product.id } }

  context 'when success' do
    let(:product) { create(:product) }

    it { expect { result }.to change(Product, :count).by(1) }
    it { expect { result }.to change(Cart, :count).by(1) }
    it { expect { result }.to change(CartItem, :count).by(1) }
  end

  context 'when fail' do
    let(:product) { create(:product) }

    before do
      allow(Product).to receive(:find).and_raise(StandardError, 'Test error')
    end

    it { expect(result).to eq({ error: 'Test error' }) }
  end
end
