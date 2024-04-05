class ProductsController < ApplicationController
  def search
    @results = Product.search(params[:search], params[:search_option])#params[:search] is the search term, and params[:search_option] is the search option
  end

  def show
    @product = Product.find(params[:id])
  end
end


