Spree::Admin::GeneralSettingsController.class_eval do
  before_filter :load_order_constraints_preferences, only: :edit

  private

  def load_order_constraints_preferences
    @preferences_order_constraints = [:checkout_allowed_from,
      :checkout_allowed_until, :maximum_items_per_month]
  end
end
