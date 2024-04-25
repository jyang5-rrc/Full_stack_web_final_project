class ProductsController < ApplicationController

  before_action :set_breadcrumbs

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

  private

  def set_breadcrumbs
    add_breadcrumb 'Home', root_path
    # Add additional breadcrumbs for three levels of depth
    if params[:action] == 'show' && params[:id]
      @product = Product.find(params[:id])
      add_breadcrumb 'Categories', categories_path
      add_breadcrumb @product.category.category_name, category_path(@product.category)
      add_breadcrumb @product.product_name, product_path(@product)
    elsif params[:controller] == 'categories' && params[:action] == 'show_products' && params[:id]
      @category = Category.find(params[:id])
      add_breadcrumb @category.category_name, show_products_category_path(@category)
    end
  end
end


