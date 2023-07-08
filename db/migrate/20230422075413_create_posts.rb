class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :hospital
      t.string :area
      t.string :specialty
      t.integer :fee
      t.datetime :time_in
      t.datetime :time_out
      t.text :notes
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
