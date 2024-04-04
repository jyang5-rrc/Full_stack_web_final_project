class ProductType < ApplicationRecord
  has_many :products

  validates :product_type_name, presence: true
end
