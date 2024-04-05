class TaxRate < ApplicationRecord
  has_many :orders

  validates :country, presence: true
  validates :state, uniqueness: { scope: :city }  # Ensure uniqueness per city in a state
  validates :tax_rate, presence: true, numericality: true
end
