require 'spec_helper'

module Spree
  describe Order do
    let(:prefs) { Spree::Config }

    describe '#checkout_allowed?' do
      before(:each) do
        Rails.cache.clear
        prefs.order_start_date_constraint = nil
        prefs.order_end_date_constraint = nil
      end

      context 'when order does not have line items' do
        let(:order) { create(:order) }

        it 'returns false' do
          expect(order.checkout_allowed?).to be false
        end
      end

      context 'when order has line items' do
        let(:order) { create(:order_with_line_items) }

        it 'returns true' do
          expect(order.checkout_allowed?).to be true
        end

        context 'when start and end date constraint is not set' do

          it 'returns true' do
            expect(order.checkout_allowed?).to be true
          end
        end

        context 'when start and end date constraints are set' do
          let(:two_days_ago) { 2.days.ago }
          let(:two_days_from_now) { 2.days.from_now }

          before do
            prefs.order_start_date_constraint = two_days_ago
            prefs.order_end_date_constraint = two_days_from_now
          end

          context 'and today is in range' do
            it 'returns true' do
              Timecop.freeze(Time.now)
              expect(order.checkout_allowed?).to be true
            end
          end

          context 'and today is not in range' do
            it 'returns false' do
              Timecop.freeze(3.days.from_now)
              expect(order.checkout_allowed?).to be false
            end
          end
        end
      end
    end
  end
end
