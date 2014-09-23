Spree::Order.class_eval do
  def self.checkout_allowed_from
    Spree::Config.checkout_allowed_from.try(:to_datetime) || DateTime.new
  end

  def self.checkout_allowed_until
    Spree::Config.checkout_allowed_until.try(:to_datetime) || DateTime::Infinity.new
  end

  def checkout_allowed?
    has_line_items? && Spree::Order.checkout_allowed_now?
  end

  private

  def self.checkout_allowed_now?
    allowed_datetime_range.cover?(DateTime.now)
  end

  def self.allowed_datetime_range
    checkout_allowed_from..checkout_allowed_until
  end

  def has_line_items?
    line_items.count > 0
  end
end
