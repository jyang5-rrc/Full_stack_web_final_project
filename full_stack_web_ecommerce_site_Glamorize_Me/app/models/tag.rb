class Tag < ApplicationRecord
  has_many :product_tags
  has_many :products, through: :product_tags

  validates :tag_name, presence: true
end
