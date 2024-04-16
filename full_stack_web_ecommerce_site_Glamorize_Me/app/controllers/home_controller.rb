class HomeController < ApplicationController
  def index
    @categories = Category.all
    @brands = Brand.all
    @product_types = ProductType.all
    @recommended_products = Product.where('rating >= ? AND price > ?', 5, 0).limit(4)
    @new_products = Product.where('created_at >= ?', 3.days.ago)
                         .order(created_at: :desc)
                         .limit(4)
    # @recently_updated_products = Product.where('updated_at >= ? AND created_at < ?', 3.days.ago, 3.days.ago)
    #                                     .order(updated_at: :desc)
    #                                     .limit(4)

    @recently_updated_products = Product.where('updated_at >= ? ', 3.days.ago)
                                        .order(updated_at: :desc)
                                        .limit(4)

  end
end
