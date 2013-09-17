class CreateThings < ActiveRecord::Migration
  def change
    create_table :things do |t|
      t.string :email
      t.string :password
      t.text :description
      t.string :radio_options
      t.boolean :checkbox_option
      t.string :file_name
      t.string :telephone_number
      t.string :url
      t.integer :count
      t.date :my_date
      t.time :my_time
      t.datetime :my_datetime
      t.string :choice

      t.timestamps
    end
  end
end
