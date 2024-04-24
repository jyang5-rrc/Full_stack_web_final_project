class OrdersController < ApplicationController

  before_action :authenticate_user!

  before_action :set_cart_items_and_cart, only: [:new, :create]

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    # Logic for creating the order goes here
    if params[:order][:use_default_address] == '1'
      # Set the order's address fields to the user's default address
      @order.assign_attributes(
        shipping_address: current_user.default_address,
        shipping_city: current_user.default_city,
        shipping_state: current_user.default_state,
        shipping_country: current_user.default_country,
        shipping_postcode: current_user.default_postcode
      )
    end

    if @order.save
      # Handle a successful save
      flash[:success] = "Order placed successfully!"
      redirect_to root_path # Or wherever you want to redirect
    else
      render :new
    end
  end

  private

  def set_cart_items_and_cart
    @cart_items = current_cart.cart_items.includes(:product)
    @cart = current_cart
  end

  def order_params
    params.require(:order).permit(:shipping_address, :shipping_city, :shipping_state, :shipping_country, :shipping_postcode, :use_default_address)
  end


end
