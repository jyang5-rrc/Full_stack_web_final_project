class ProductsController < ApplicationController
  def search
    @results = Product.search(params[:search], params[:search_option]).page(params[:page]).per(10)#params[:search] is the search term, and params[:search_option] is the search option
    @total_records = @results.total_count
  end

  def show
    @product = Product.find(params[:id])
    if @product.nil?
      redirect_to some_path, alert: "Product not found"
    end
  end
end


