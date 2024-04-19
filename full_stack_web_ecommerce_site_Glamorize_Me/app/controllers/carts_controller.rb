class CartsController < ApplicationController
  def show
    @cart = find_or_initialize_cart
    @cart_items = @cart.cart_items
  end

  private # private methods are only accessible within the class they are defined in

  def find_or_initialize_cart
    if current_user.cart
      current_user.cart
    else
      cart = Cart.create(user_id: current_user.id)
      current_user.cart = cart
      cart
    end
  end



  def add_to_cart
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

  def remove_from_cart
    cart_item = CartItem.find(params[:cart_item_id])
    cart_item.destroy
    redirect_to cart_path
  end

  def update_cart
    cart_item = CartItem.find(params[:cart_item_id])
    cart_item.quantity = params[:quantity]
    cart_item.save
    redirect_to cart_path
  end

  def checkout
    cart = current_user.cart
    cart_items = cart.cart_items

    order = Order.create(user_id: current_user.id)
    cart_items.each do |cart_item|
      OrderProduct.create(order_id: order.id, product_id: cart_item.product_id, quantity: cart_item.quantity)
    end

    cart_items.destroy_all
    redirect_to cart_path
  end

  def empty_cart
    cart = current_user.cart
    cart.cart_items.destroy_all
    redirect_to cart_path
  end

  def destroy
    cart = current_user.cart
    cart.destroy
    redirect_to cart_path
  end


end
