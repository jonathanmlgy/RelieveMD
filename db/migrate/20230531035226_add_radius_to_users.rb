class AddRadiusToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :radius, :integer, default: 10
  end
end
