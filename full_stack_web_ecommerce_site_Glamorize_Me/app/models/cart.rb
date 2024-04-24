class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  def add_product(product, quantity = 1)
    current_item = cart_items.find_by(product_id: product.id)

    if current_item
      if current_item.quantity.present?
        current_item.quantity += quantity.to_i
      else
        current_item.quantity = quantity.to_i
      end
    else
      current_item = cart_items.build(product_id: product.id, quantity: quantity.to_i)
    end

  end

  #method to count the number of items in the cart
  def total_items
    cart_items.sum(:quantity) #sum of the quantity of all items in the cart

  end

  # Method to calculate total price, etc.
  def total_price
    cart_items.to_a.sum(&:total_price)
  end


end
