class CategoriesController < ApplicationController

  before_action :set_breadcrumbs

  def categories
    @categories = Category.all
  end

  def show_products
    @category = Category.find(params[:id])
    @products = @category.products.page(params[:page]).per(10)  # Display 10 products per page
  end


  private

  def set_breadcrumbs
    add_breadcrumb 'Home', root_path
    if params[:action] == 'categories'
      @categories = Category.all
      add_breadcrumb 'Categories'

    elsif params[:action] == 'show_products' && params[:id]
      @category = Category.find(params[:id])
      add_breadcrumb 'Categories', categories_path
      add_breadcrumb @category.category_name, show_products_category_path(@category)


    end
  end
end
