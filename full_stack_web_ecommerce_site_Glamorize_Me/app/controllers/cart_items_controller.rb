class CartItemsController < ApplicationController
  # Add methods to create, update, and destroy cart items
  def create
    product = Product.find(params[:product_id])
    cart = current_user.cart
    cart_item = cart.cart_items.find_by(product_id: product.id)

    if cart_item
      cart_item.quantity += 1
      cart_item.save
    else
      cart_item = cart.cart_items.new(product_id: product.id, quantity: 1)
      cart_item.save
    end

    redirect_to cart_path
  end

  def update
    cart_item = CartItem.find(params[:id])
    cart_item.quantity = params[:quantity]
    cart_item.save
    redirect_to cart_path
  end

  def destroy
    cart_item = CartItem.find(params[:id])
    cart_item.destroy
    redirect_to cart_path
  end


end
