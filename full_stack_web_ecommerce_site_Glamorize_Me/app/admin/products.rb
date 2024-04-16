ActiveAdmin.register Product do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :product_name, :brand_id, :price, :image_link, :description, :rating, :category_id, :product_type_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:product_name, :brand_id, :price, :image_link, :description, :rating, :category_id, :product_type_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  permit_params :product_name, :brand_id, :price, :image_link, :description, :rating, :category_id, :product_type_id, :image

  index do
    selectable_column
    id_column
    column :product_name
    column :brand, sortable: 'brand.brand_name' do |product|
      product.brand.brand_name if product.brand
    end
    column :price
    column :image_link
    column :description
    column :rating
    column :category, sortable: 'category.category_name' do |product|
      product.category.category_name if product.category
    end
    column :product_type, sortable: 'product_type.product_type_name' do |product|
      product.product_type.product_type_name if product.product_type
    end
    column :tags do |product|
      product.tags.map { |tag| tag.tag_name }.join(", ").html_safe # Display tags as a comma-separated list,from table product_tags
    end
    column :created_at

    actions
  end

  filter :brand, as: :select, collection: Brand.all.map { |brand| [brand.brand_name, brand.id] }
  filter :price
  filter :rating
  filter :category_id, as: :select, collection: -> { Category.all.pluck(:category_name, :id) }
  # Filter by category name using the ransacker
  # filter :category_name_cont, as: :string
  filter :product_type_id, as: :select, collection: -> { ProductType.all.pluck(:product_type_name, :id) }
  # Filter by product_type name using the ransacker
  # filter :product_type_name_cont, as: :string


  form do |f|
    f.inputs do
      f.input :product_name
      f.input :image, as: :file, hint: f.object.image.attached? ? image_tag(f.object.image, size: "150x150") : content_tag(:span, "Upload an image")
      f.input :brand, as: :select, collection: Brand.all.map { |brand| [brand.brand_name, brand.id] }
      f.input :price
      f.input :image_link
      f.input :description
      f.input :rating
      f.input :category, as: :select, collection: Category.all.map { |category| [category.category_name, category.id] }
      f.input :product_type, as: :select, collection: ProductType.all.map { |product_type| [product_type.product_type_name, product_type.id] }
      f.input :tags, as: :check_boxes, collection: Tag.all.map { |tag| [tag.tag_name, tag.id] }
    end
    f.actions
  end


  show do |product|
    attributes_table do
      row :product_name
      row :image do |product| if product.image.attached?
          image_tag product.image, size: "150x150"
        else
          content_tag(:span, "No image available")
        end
      end
      row :brand do |product|
        product.brand.brand_name if product.brand
      end
      row :price
      row :image_link
      row :description
      row :rating
      row :category do |product|
        product.category.category_name if product.category
      end
      row :product_type do |product|
        product.product_type.product_type_name if product.product_type
      end
      row :tags do |product|
        product.tags.map { |tag| tag.tag_name }.join(", ").html_safe
      end
      row :created_at
    end
  end


end
