Spree::Order.class_eval do

  def checkout_allowed?
    have_line_items? &&
    Rails.application.config.spree.preferences.order_allowed_time_range?
  end

  private

  def have_line_items?
    line_items.count > 0
  end
end
