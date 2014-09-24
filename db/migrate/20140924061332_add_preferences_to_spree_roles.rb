class AddPreferencesToSpreeRoles < ActiveRecord::Migration
  def change
    add_column :spree_roles, :preferences, :text
  end
end
