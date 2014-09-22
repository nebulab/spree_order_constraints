Spree::AppConfiguration.class_eval do
  preference :order_start_date_constraint, :string
  preference :order_end_date_constraint, :string
  preference :order_line_items_constraint, :integer

  def order_allowed_time_range?
    order_constraint_range.cover?(Time.now.to_f)
  end

  def order_start_date_constraint
    get(:order_start_date_constraint).try(:to_time)
  end

  def order_end_date_constraint
    get(:order_end_date_constraint).try(:to_time)
  end

  def order_constraint_range
    start_date = order_start_date_constraint || Time.now
    end_date = order_end_date_constraint || Float::INFINITY
    start_date.to_f..end_date.to_f
  end
end
