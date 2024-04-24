class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :user
  belongs_to :product

  validates :user_id, presence: true


  # Returns the total price of the cart item
  def total_price
    (product.price || 0) * (quantity || 0)
  end

  # Define a method to calculate the price
  def calculate_price
    # Assuming each cart item has an associated product with a price attribute
    self.quantity * self.product.price
  end

  # Class method to calculate the total price for a collection of cart items
  def self.calculate_total_price(items)
    items.sum(&:calculate_price)
  end
end
