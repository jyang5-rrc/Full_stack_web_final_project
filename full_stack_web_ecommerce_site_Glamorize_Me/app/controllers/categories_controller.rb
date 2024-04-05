class CategoriesController < ApplicationController
  def categories
    @categories = Category.all
  end

  def show_products
    @category = Category.find(params[:id])
    @products = @category.products
  end
end
