Spree::Order.class_eval do

  def checkout_allowed?
    has_line_items? && Spree::Config.order_allowed_time_range?
  end

  private

  def has_line_items?
    line_items.count > 0
  end
end
