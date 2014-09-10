Spree::Order.class_eval do

  def checkout_allowed?
    have_line_items?
  end

  private

  def have_line_items?
    line_items.count > 0
  end
end
