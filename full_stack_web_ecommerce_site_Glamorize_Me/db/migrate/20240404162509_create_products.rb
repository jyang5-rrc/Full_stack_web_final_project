class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :product_name
      t.references :brand, null: false, foreign_key: true
      t.decimal :price, precision: 5, scale: 2
      t.text :image_link
      t.text :description
      t.decimal :rating, precision: 2, scale: 1
      t.references :category, null: false, foreign_key: true
      t.references :product_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
