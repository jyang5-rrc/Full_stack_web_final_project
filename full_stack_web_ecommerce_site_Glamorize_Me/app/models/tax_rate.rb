class TaxRate < ApplicationRecord
  has_many :orders

  validates :country, presence: true, uniqueness: true
  validates :state, presence: true, uniqueness: true
  validates :tax_rate, presence: true, numericality: true
end
