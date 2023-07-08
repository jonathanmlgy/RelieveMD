class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password
      t.string :confirm_password
      t.string :education
      t.string :experience
      t.string :area

      t.timestamps
    end
  end
end
