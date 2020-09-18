class CreateRestaurants < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.text :memo
      t.date :added_on

      t.timestamps
    end
  end
end
