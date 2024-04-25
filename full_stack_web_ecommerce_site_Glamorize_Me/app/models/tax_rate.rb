class TaxRate < ApplicationRecord
  has_many :orders

  validates :country, presence: true
  validates :state, uniqueness: { scope: :city }  # Ensure uniqueness per city in a state

end
