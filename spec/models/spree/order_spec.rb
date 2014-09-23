require 'spec_helper'

module Spree
  describe Order do
    describe '.checkout_allowed_from' do
      it 'returns a datetime' do
        today = Time.now
        Spree::Config.checkout_allowed_from = today

        expect(Spree::Order.checkout_allowed_from).to eq_to_time today
      end
    end

    describe '.checkout_allowed_until' do
      it 'returns a datetime' do
        today = Time.now
        Spree::Config.checkout_allowed_until = today

        expect(Spree::Order.checkout_allowed_until).to eq_to_time today
      end
    end

    describe '#checkout_allowed?' do
      before(:each) do
        Spree::Config.checkout_allowed_from = nil
        Spree::Config.checkout_allowed_until = nil
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
          before do
            Spree::Config.checkout_allowed_from = 2.days.ago
            Spree::Config.checkout_allowed_until = 2.days.from_now
          end

          context 'and today is in range' do
            before { Timecop.freeze }

            it 'returns true' do
              expect(order.checkout_allowed?).to be true
            end
          end

          context 'and today is not in range' do
            before { Timecop.freeze(3.days.from_now) }

            it 'returns false' do
              expect(order.checkout_allowed?).to be false
            end
          end
        end

        context 'when an item limit is set' do
        end
      end
    end
  end
end
