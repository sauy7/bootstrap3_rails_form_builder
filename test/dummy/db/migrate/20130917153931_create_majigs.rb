class CreateMajigs < ActiveRecord::Migration
  def change
    create_table :majigs do |t|
      t.string :foo
      t.references :thing

      t.timestamps
    end
  end
end
