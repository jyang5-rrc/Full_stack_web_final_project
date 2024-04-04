class CreateAdministrators < ActiveRecord::Migration[7.1]
  def change
    create_table :administrators do |t|
      t.string :name
      t.string :email
      t.references :role, null: false, foreign_key: true
      t.string :password

      t.timestamps
    end
  end
end
