require 'spec_helper'

module Spree
  describe Order do
    describe '#checkout_allowed?' do
      let(:prefs) { Rails.application.config.spree.preferences }

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

      context 'when order have line items' do
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
          before do
            prefs.order_start_date_constraint = Time.local(2014, 1, 1)
            prefs.order_end_date_constraint = Time.local(2014, 1, 7)
          end

          context 'and today is in range' do
            it 'returns true' do
              Timecop.freeze(Time.local(2014, 1, 3))
              expect(order.checkout_allowed?).to be true
            end
          end

          context 'and today is not in range' do
            it 'returns false' do
              Timecop.freeze(Time.local(2014, 1, 10))
              expect(order.checkout_allowed?).to be false
            end
          end
        end
      end
    end
  end
end
