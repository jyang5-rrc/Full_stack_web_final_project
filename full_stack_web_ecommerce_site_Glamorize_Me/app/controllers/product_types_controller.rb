class ProductTypesController < ApplicationController
  def product_types
    @product_types = ProductType.all
  end

  def show_products
    @product_type = ProductType.find(params[:id])
    @products = @product_type.products
  end
end
