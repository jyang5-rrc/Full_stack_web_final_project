ActiveAdmin.register ProductType do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :product_type_name
  #
  # or
  #
  # permit_params do
  #   permitted = [:product_type_name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  permit_params :product_type_name

  index do
    selectable_column
    id_column
    column :product_type_name
    actions
  end

  filter :product_type_name
  filter :created_at
  #filter :products_name_cont, as: 'string'  # This allows filtering categories based on the names of their products

  form do |f|
    f.inputs do
      f.input :product_type_name
    end
    f.actions
  end

end
