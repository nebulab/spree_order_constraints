require 'spec_helper'

describe Spree::CheckoutController, :type => :controller do
  let(:user) { stub_model(Spree::LegacyUser) }
  let(:order) { FactoryGirl.create(:order_with_totals) }

  before do
    allow(controller).to receive(:try_spree_current_user).and_return(user)
    allow(controller).to receive(:current_order).and_return(order)
  end

  context "#edit" do
    before do
      Spree::Config.checkout_allowed_from = Date.tomorrow
      Spree::Config.checkout_allowed_until = Date.tomorrow + 1
      Spree::Config.maximum_items_per_month = 3
      allow(order).to receive(:checkout_allowed?).and_return(false)
      spree_get :edit, { :state => 'address' }
    end

    context 'unless checkout_allowed?' do
      it 'redirects to the cart path' do
        expect(response).to redirect_to(spree.cart_path)
      end

      it 'sets flash error message' do
        expect(flash[:error]).to eq(
          Spree.t(:order_constraints_error,
                  from: I18n.l(Spree::Order.checkout_allowed_from.to_date, format: :short),
                  to: I18n.l(Spree::Order.checkout_allowed_until.to_date, format: :short),
                  maximum_items: Spree::Config.maximum_items_per_month)
        )
      end
    end
  end
end
