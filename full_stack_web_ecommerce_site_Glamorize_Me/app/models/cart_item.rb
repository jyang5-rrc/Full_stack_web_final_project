class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  # Method to calculate total price, etc.

  def total_price
    cart_items.to_a.sum { |item| item.total_price }
  end

end
