# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to belong_to(:cart) }
  end
end
