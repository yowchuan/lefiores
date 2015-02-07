class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.string :att1
      t.integer :att2

      t.timestamps null: false
    end
  end
end
