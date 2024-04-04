class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.datetime :order_date
      t.string :shipping_address
      t.string :shipping_city
      t.string :shipping_state
      t.string :shipping_country
      t.string :shipping_postcode
      t.references :user, null: false, foreign_key: true
      t.references :status, null: false, foreign_key: true
      t.references :tax_rate, null: false, foreign_key: true

      t.timestamps
    end
  end
end
