class AddDetailsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :default_city, :string
    add_column :users, :default_state, :string
    add_column :users, :default_country, :string
    add_column :users, :default_postcode, :string
  end
end
