class Brand < ApplicationRecord
  has_many :products

  validates :brand_name, presence: true, uniqueness: true
end
