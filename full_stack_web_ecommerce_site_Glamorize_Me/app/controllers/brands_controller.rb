class BrandsController < ApplicationController
  def brands
    @brands = Brand.page(params[:page]).per(20) # paginate 20 brands per page
  end

  def show_products
    @brand = Brand.find(params[:id])
    @products = @brand.products
  end
end
