class AddRestidToRestaurants < ActiveRecord::Migration[5.2]
  def change
    add_column :restaurants, :restid, :string
  end
end
