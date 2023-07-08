class AddLongitudeAndLatitudeToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :longitude, :float
    add_column :posts, :latitude, :float
  end
end
