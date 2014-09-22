Spree::Admin::GeneralSettingsController.class_eval do
  before_filter :load_order_constraints_preferences, only: :edit

  private

  def load_order_constraints_preferences
    @preferences_order_constraints = [:order_start_date_constraint,
      :order_end_date_constraint]
  end
end
