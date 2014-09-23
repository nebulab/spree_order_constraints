Spree::AppConfiguration.class_eval do
  preference :checkout_allowed_from, :string
  preference :checkout_allowed_until, :string
  preference :order_line_items_constraint, :integer
end
