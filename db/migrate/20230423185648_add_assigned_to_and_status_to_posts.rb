class AddAssignedToAndStatusToPosts < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :assigned_to, foreign_key: { to_table: :users }
    add_column :posts, :status, :integer
  end
end
