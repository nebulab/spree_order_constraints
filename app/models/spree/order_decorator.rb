Spree::Order.class_eval do
  def self.checkout_allowed_from
    Spree::Config.checkout_allowed_from.try(:to_datetime) || DateTime.new
  end

  def self.checkout_allowed_until
    Spree::Config.checkout_allowed_until.try(:to_datetime) || DateTime::Infinity.new
  end

  def maximum_items_per_month
    user.spree_roles.map(&:preferred_maximum_items_per_month).max ||
    Spree::Config.maximum_items_per_month
  end

  def checkout_allowed?
    has_line_items? &&
    Spree::Order.checkout_allowed_now? &&
    items_constraint_respected?
  end

  private

  def self.allowed_datetime_range
    checkout_allowed_from..checkout_allowed_until
  end

  def self.checkout_allowed_now?
    allowed_datetime_range.cover?(DateTime.now)
  end

  def self.completed_this_month_by_customer(customer_email)
    this_month = [DateTime.now.beginning_of_month, DateTime.now.end_of_month]

    by_customer(customer_email).by_state(:complete).completed_between(*this_month)
  end

  def has_line_items?
    line_items.count > 0
  end

  def items_constraint_respected?
    maximum_items_per_month.nil? ||
    items_for_customer_this_month <= maximum_items_per_month
  end

  def items_for_customer_this_month
    items_to_buy         = line_items.sum(:quantity)
    items_already_bought = Spree::Order.completed_this_month_by_customer(email).
                            joins(:line_items).
                            sum(:quantity)

    items_to_buy + items_already_bought
  end
end
