ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :email, :age, :gender, :password, :default_address, :default_city, :default_state, :default_country, :default_postcode, :password_digest
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :email, :age, :gender, :password, :default_address, :default_city, :default_state, :default_country, :default_postcode, :password_digest]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  permit_params :email, :password, :default_address, :default_city, :default_state, :default_country, :default_postcode # Add other necessary parameters

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :age
    column :gender
    column :default_address
    column :default_city
    column :default_state
    column :default_country
    column :default_postcode
    actions
  end

  filter :email
  filter :age
  filter :gender
  filter :default_country
  filter :default_city
  filter :default_state


  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :age
      f.input :gender
      f.input :default_address
      f.input :default_city
      f.input :default_state
      f.input :default_country, as: :string, priority_countries: ["US", "CA"], input_html: { class: 'country-select' }
      f.input :default_postcode
      f.input :password
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :email
      row :age
      row :gender
      row :default_address
      row :default_city
      row :default_state
      row :default_country
      row :default_postcode
    end
  end

  remove_filter :password_digest
end