class CreateTaxRates < ActiveRecord::Migration[7.1]
  def change
    create_table :tax_rates do |t|
      t.string :country
      t.string :state
      t.string :city
      t.decimal :tax_rate, precision: 2, scale: 1

      t.timestamps
    end
  end
end
