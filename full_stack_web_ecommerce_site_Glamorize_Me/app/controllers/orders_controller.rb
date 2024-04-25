class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart_items_and_cart, only: [:new, :create]


  include OrdersHelper

  def index
    @order = Order.all
  end

  def new
    Rails.logger.debug "Parameters received in new action: #{params.inspect}"
    @order = Order.new
    @cart_items = current_cart.cart_items.includes(:product)
    @cart = current_cart
    set_customer_address(current_user)
    @tax_rate = tax_rate_for_address(@customer_address)
    calculate_taxes(@cart.total_price, @tax_rate)
  end


  def create
    @order = current_user.orders.build(order_params)
    @order.status = Status.find_or_create_by(name: "Pending")
    @order.order_date = Date.today

    # # Debug statement
    # string = @order.attributes.map{|key, value| "#{key}: #{value}"}.join('|')
    # Rails.logger.debug "Order before address assignment: #{string}"


    # string = current_user.attributes.map{|key, value| "#{key}: #{value}"}.join('|')
    # Rails.logger.debug "User: #{string}"

    # Rails.logger.debug "Params: #{params}"

    # Rails.logger.debug "Params: #{params[:order][:use_default_address]}"

      set_default_address(current_user)

    # string = @order.attributes.map{|key, value| "#{key}: #{value}"}.join('|')
    # Rails.logger.debug "Order AFTER address assignment: #{string}"

    ActiveRecord::Base.transaction do
      @order.tax_rate = determine_tax_rate(@order.shipping_state, @order.shipping_country)
      calculate_taxes(@cart.total_price, @order.tax_rate)

      # Debug statement
      Rails.logger.debug "Order after tax rate assignment: #{@order.shipping_state}, #{@order.shipping_country}"

      @order.save!
      create_order_products(@order, @cart)

      # Consider whether you want to clear the cart at this point or after successful payment
      @cart.clear

      redirect_to checkout_order_path(@order)
    end

  rescue ActiveRecord::RecordInvalid => e
    # This will run if either order or order_products couldn't be saved.
    # You will have access to the specific exception in the variable `e`.
    set_customer_address(current_user) # Reset customer address in case save fails
    flash.now[:error] = "Error placing order: #{e.message}"
    render :new
  end


  def checkout
    @order = Order.find(params[:id])
    @customer_address = build_customer_address(@order)
    # Additional checkout logic...

    render 'checkout'
  end

  private

  def set_cart_items_and_cart
    @cart_items = current_cart.cart_items.includes(:product)
    @cart = current_cart
  end

  def order_params
    params.require(:order).permit(:shipping_address, :shipping_city, :shipping_postcode, :shipping_state, :shipping_country, :status_id, :tax_rate_id, :user_id, :order_date)
  end

  def set_customer_address(user)
    # if params[:use_default_address] == '1'
      @customer_address = {
        name: user.name,
        street_address: user.default_address,
        city: user.default_city,
        province: user.default_state,
        country: user.default_country,
        postal_code: user.default_postcode
      }
    # elseif params[:order].present?
    #   @customer_address = {
    #     name: user.name,
    #     street_address: params[:order][:shipping_address],
    #     city: params[:order][:shipping_city],
    #     province: params[:order][:shipping_state],
    #     country: params[:order][:shipping_country],
    #     postal_code: params[:order][:shipping_postcode]
    #   }
    # else
    #   # Handle the case where params[:order] is nil or empty
    #   flash[:error] = "No order parameters found"
    #   # You can set a default address or raise an error as needed

    # end
  end


  def set_default_address(user)

    string = user.attributes.map{|key, value| "#{key}: #{value}"}.join('|')
    Rails.logger.debug "User2: #{string}"

    @order.assign_attributes(
      shipping_address: user.default_address,
      shipping_city: user.default_city,
      shipping_state: user.default_state,
      shipping_country: user.default_country,
      shipping_postcode: user.default_postcode
    )
  end

  def set_address_from_params
    @order.assign_attributes(order_params)
  end


  # def determine_tax_rate(state, country)
  #   TaxRate.find_by(state: state, country: country) || TaxRate.new(pst: 0, gst: 0, hst: 0)
  # end

  def calculate_taxes(total_price, tax_rate)
    Rails.logger.debug "Calculating taxes: Total Price: #{total_price}, PST: #{tax_rate.pst}, GST: #{tax_rate.gst}, HST: #{tax_rate.hst}"
    @pst = (tax_rate.pst || 0) * total_price
    @gst = (tax_rate.gst || 0) * total_price
    @hst = (tax_rate.hst || 0) * total_price
    Rails.logger.debug "Calculated taxes: PST: #{@pst}, GST: #{@gst}, HST: #{@hst}"
  end


  def build_customer_address(order)
    {
      name: order.user.name,
      street_address: order.shipping_address,
      city: order.shipping_city,
      province: order.shipping_state,
      country: order.shipping_country,
      postal_code: order.shipping_postcode
    }
  end

  def create_order_products(order, cart)
    cart.cart_items.each do |cart_item|
      order.order_products.create!(
        product_id: cart_item.product_id,
        quantity: cart_item.quantity,
        price_at_time_of_order: cart_item.product.price # Assuming you have price on product
      )
    end
  end

end
