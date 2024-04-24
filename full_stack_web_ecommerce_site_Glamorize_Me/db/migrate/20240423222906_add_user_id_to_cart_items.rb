class AddUserIdToCartItems < ActiveRecord::Migration[7.1]
  def change
    add_column :cart_items, :user_id, :integer
  end
end
