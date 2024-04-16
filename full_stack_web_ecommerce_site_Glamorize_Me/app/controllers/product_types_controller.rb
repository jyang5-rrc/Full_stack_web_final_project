class ProductTypesController < ApplicationController
  def product_types
    @product_types = ProductType.all
  end

  def show_products
    @product_type = ProductType.find(params[:id])
    @products = @product_type.products.page(params[:page]).per(10)  # Display 10 products per page
  end
end
