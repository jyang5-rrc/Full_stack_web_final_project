class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.references :product, null: false, foreign_key: true
      t.text :comment
      t.decimal :rating, precision: 2, scale: 1
      t.text :comment_image_link

      t.timestamps
    end
  end
end
