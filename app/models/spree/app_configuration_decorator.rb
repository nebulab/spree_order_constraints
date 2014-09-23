Spree::AppConfiguration.class_eval do
  preference :checkout_allowed_from, :string
  preference :checkout_allowed_until, :string
  preference :maximum_items_per_month, :integer
end
