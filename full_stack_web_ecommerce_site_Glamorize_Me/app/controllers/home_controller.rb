class HomeController < ApplicationController
  def index
    @categories = Category.all
    @brands = Brand.all
    @product_types = ProductType.all
    @recommended_products = Product.where('rating >= ? AND price > ?', 5, 0).limit(4)

  end
end
