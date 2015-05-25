Spree::Order.class_eval do
  # FIX: taken from the old spree 2.4 branch. they were removed from spree 3.0
  def self.by_customer(customer)
    joins(:user).where("#{Spree.user_class.table_name}.email" => customer)
  end

  def self.by_state(state)
    where(state: state)
  end
  # /FIX

  def self.checkout_allowed_from
    if Spree::Config.checkout_allowed_from.blank?
      today = Date.today
      return DateTime.new(today.year, today.month)
    end
    Spree::Config.checkout_allowed_from.try(:to_datetime).try(:beginning_of_day)
  end

  def self.checkout_allowed_until
    if Spree::Config.checkout_allowed_until.blank?
      today = Date.today
      return DateTime.new(today.year, today.month).end_of_month
    end
    Spree::Config.checkout_allowed_until.try(:to_datetime).try(:end_of_day)
  end

  def maximum_items_per_month
    user.spree_roles.map(&:preferred_maximum_items_per_month).max ||
    Spree::Config.maximum_items_per_month ||
    1
  end

  module OverrideCheckoutAllowed
    def checkout_allowed?
      super &&
      Spree::Order.checkout_allowed_now? &&
      items_constraint_respected?
    end
  end
  prepend OverrideCheckoutAllowed

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
