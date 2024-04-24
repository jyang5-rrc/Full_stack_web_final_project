class AddTaxDetailsToTaxRates < ActiveRecord::Migration[6.0]
  def change
    add_column :tax_rates, :pst, :decimal, precision: 5, scale: 2
    add_column :tax_rates, :gst, :decimal, precision: 5, scale: 2
    add_column :tax_rates, :hst, :decimal, precision: 5, scale: 2
  end
end

