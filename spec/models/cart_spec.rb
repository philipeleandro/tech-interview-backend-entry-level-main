# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cart do
  describe 'associations' do
    it { is_expected.to have_many(:cart_items) }
  end

  describe 'validations' do
    it { is_expected.to validate_numericality_of(:total_price) }
  end

  context 'when validating' do
    it 'validates numericality of total_price' do
      cart = described_class.new(total_price: -1)
      expect(cart).not_to be_valid
      expect(cart.errors[:total_price]).to include('must be greater than or equal to 0')
    end
  end

  describe 'mark_as_abandoned' do
    let(:shopping_cart) { create(:shopping_cart) }

    it 'marks the shopping cart as abandoned if inactive for a certain time' do
      shopping_cart.update(last_interaction_at: 3.hours.ago)
      expect do
        shopping_cart.mark_as_abandoned
      end.to change(shopping_cart, :abandoned?).from(false).to(true)
    end
  end

  describe 'remove_if_abandoned' do
    let(:shopping_cart) { create(:shopping_cart, last_interaction_at: 7.days.ago) }

    it 'removes the shopping cart if abandoned for a certain time' do
      shopping_cart.mark_as_abandoned
      expect { shopping_cart.remove_if_abandoned }.to change(described_class, :count).by(-1)
    end
  end
end
