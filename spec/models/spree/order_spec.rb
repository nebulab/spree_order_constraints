require 'spec_helper'

module Spree
  describe Order do
    describe '#checkout_allowed?' do
      context 'when order does not have line items' do
        let(:order) { create(:order) }

        it 'returns false' do
          expect(order.checkout_allowed?).to be false
        end
      end

      context 'when order have line items' do
        let(:order) { create(:order_with_line_items) }

        it 'returns true' do
          expect(order.checkout_allowed?).to be true
        end
      end
    end
  end
end
