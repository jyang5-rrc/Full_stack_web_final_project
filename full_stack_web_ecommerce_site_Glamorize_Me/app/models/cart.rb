class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy


  #method to count the number of items in the cart
  def total_items
    cart_items.sum(:quantity) #sum of the quantity of all items in the cart

  end

  # Method to calculate total price, etc.
  def total_price
    cart_items.to_a.sum { |item| item.total_price }
  end


end
