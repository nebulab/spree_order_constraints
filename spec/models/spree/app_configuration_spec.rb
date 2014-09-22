require 'spec_helper'

module Spree
  describe AppConfiguration do
    let(:prefs) { Spree::Config }

    before(:each) do
      Rails.cache.clear
    end

    describe '.order_start_date_constraint' do
      it 'returns a datetime' do
        today = Time.now
        prefs.order_start_date_constraint = today

        expect(prefs.order_start_date_constraint).to eq_to_time today
      end
    end

    describe '.order_end_date_constraint' do
      it 'returns a datetime' do
        today = Time.now
        prefs.order_end_date_constraint = today

        expect(prefs.order_end_date_constraint).to eq_to_time today
      end
    end

    describe '.order_constraint_range' do
      let(:two_days_ago) { 2.days.ago }
      let(:two_days_from_now) { 2.days.from_now }

      before { Timecop.freeze }

      context 'with defaults' do
        it 'returns the default constraint date range' do
          range = Time.now.to_f..Float::INFINITY

          expect(prefs.order_constraint_range).to eq range
        end
      end

      context 'with values set' do
        before do
          prefs.order_start_date_constraint = two_days_ago
          prefs.order_end_date_constraint = two_days_from_now
        end

        it 'returns the order constraint date range' do
          range = two_days_ago.to_s.to_time.to_f..
                  two_days_from_now.to_s.to_time.to_f

          expect(prefs.order_constraint_range).to eq range
        end
      end
    end
  end
end
