class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart
  before_action :set_product, only: [:create]
  before_action :set_cart_item, only: [:update, :destroy]  # Adjusted to include 'update'

  # POST /cart_items
  # def create
  #   puts "*********************Product ID received: #{params[:product_id]}"
  #   @current_cart.add_product(@product, cart_item_params[:quantity])

  #   if @cart_item
  #     @cart_item.quantity += cart_item_params[:quantity].to_i
  #   else
  #     @cart_item = @current_cart.cart_items.build(product: @product, quantity: cart_item_params[:quantity])
  #   end

  #   if @current_cart.save
  #     redirect_to root_path, notice: 'Product added to cart!'
  #   else
  #     redirect_to product_path(@product), alert: 'There was an issue adding the product to the cart.'
  #   end
  # end

  def create
    @cart_item = @cart.cart_items.build(cart_item_params)
    @cart_item.user = current_user  # Associate with the current user

    if @cart_item.save
      redirect_to root_path, notice: 'Product added to cart!'
    else
      redirect_to product_path(@product), alert: 'Failed to add product to cart.'
    end
  end



  def update
    @cart_item = CartItem.find(params[:id])
    respond_to do |format|
      if @cart_item.update(cart_item_params)
        format.html { redirect_to cart_items_path, notice: 'Cart item was successfully updated.' }
        format.json do
          cart = current_user.cart # Assuming current_user represents the logged-in user
          cart_total = cart.total_price # Calculate the total cart price
          render json: {
            product_id: @cart_item.product_id,
            product_total: @cart_item.product.price * @cart_item.quantity,
            cart_total: cart_total
          }
        end
        format.js # This will look for a file called `update.js.erb` in your `views/cart_items` directory

      else
        format.html { render :edit }
        format.json { render json: @cart_item.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /cart_items/:id
  def destroy
    @cart_item = CartItem.find(params[:id])
    if @cart_item.destroy
      respond_to do |format|
        format.html { redirect_to cart_path, notice: 'Item removed from cart.' }
        format.js   # This will look for a file called `destroy.js.erb` in your `views/cart_items` directory
      end
    else
      respond_to do |format|
        format.html { redirect_to cart_path, alert: 'Failed to remove item.' }
        format.js { render js: "alert('Error removing item');" }
      end
    end
  end

  private

  def set_product
    @product = Product.find_by(id: params[:cart_item][:product_id])
    unless @product
      flash[:alert] = 'Product not found'
      redirect_to root_path
    end
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity, :product_id)
  end

  def set_cart_item
    @cart_item = current_user.cart.cart_items.find(params[:id])
    unless @cart_item
      flash[:alert] = 'Cart item not found'
      redirect_to cart_path(current_user.cart)
    end
  end

  def set_cart
    if current_user
      @cart = current_user.cart || current_user.create_cart
    else
      redirect_to new_user_session_path, alert: 'You must be logged in to access this feature.'
    end
  end
end
