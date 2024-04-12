ActiveAdmin.register Administrator do
  permit_params :email, :role_id, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :role, sortable: 'role.name' do |administrator|
      administrator.role.name
    end
    column :created_at
    actions
  end

  filter :email
  filter :role, as: :select, collection: Role.all.map { |role| [role.name, role.id] }
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :role, as: :select, collection: Role.all.map { |role| [role.name, role.id] }
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
