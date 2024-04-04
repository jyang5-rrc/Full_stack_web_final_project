class CreateTrackings < ActiveRecord::Migration[7.1]
  def change
    create_table :trackings do |t|
      t.string :tracking_number
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
