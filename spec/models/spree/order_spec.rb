require 'spec_helper'

module Spree
  describe Order do
    before { reset_spree_preferences }

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

        context 'when a line item limit is set' do
          let(:this_month) { DateTime.now.beginning_of_month + 5.days }
          let!(:new_order) { create(:order_with_line_items, line_items_count: 2, user: customer) }
          let!(:old_order) { create(:completed_order_with_totals, line_items_count: 1, user: customer) }

          before { old_order.update_column(:completed_at, this_month) }

          context 'as a global preference' do
            let(:customer) { create(:user) }

            context 'and that limit is not yet reached' do
              it 'returns true' do
                Spree::Config.maximum_items_per_month = 3

                expect(new_order.checkout_allowed?).to be true
              end
            end

            context 'and that limit is reached' do
              it 'returns false' do
                Spree::Config.maximum_items_per_month = 2

                expect(new_order.checkout_allowed?).to be false
              end
            end
          end

          context 'as a preference on Spree::Role' do
            let(:customer) { create(:admin_user) }
            let(:customer_role) { customer.spree_roles.first }

            context 'and that limit is not yet reached' do
              it 'returns true' do
                Spree::Config.maximum_items_per_month = 1
                customer_role.set_preference(:maximum_items_per_month, 3)
                customer_role.save

                expect(new_order.checkout_allowed?).to be true
              end
            end

            context 'and that limit is reached' do
              it 'returns false' do
                Spree::Config.maximum_items_per_month = 4
                customer_role.set_preference(:maximum_items_per_month, 2)
                customer_role.save

                expect(new_order.checkout_allowed?).to be false
              end
            end
          end
        end
      end
    end
  end
end
