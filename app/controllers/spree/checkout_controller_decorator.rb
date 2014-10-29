Spree::CheckoutController.class_eval do
  def ensure_checkout_allowed
    unless @order.checkout_allowed?
      flash[:error] = Spree.t(:order_constraints_error,
                              from: l(Spree::Order.checkout_allowed_from.to_date, format: :short),
                              to: l(Spree::Order.checkout_allowed_until.to_date, format: :short),
                              maximum_items: @order.maximum_items_per_month)
      redirect_to spree.cart_path
    end
  end
end
