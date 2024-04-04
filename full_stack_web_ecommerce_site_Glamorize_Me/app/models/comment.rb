class Comment < ApplicationRecord
  belongs_to :product
  # belongs_to :user

  #validates :user_id, :product_id, :content, presence: true
  validates :product_id, presence: true
  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
end
