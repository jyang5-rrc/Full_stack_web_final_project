ActiveAdmin.register_page "StaticPages" do
  menu priority: 5, label: "Static Pages"

  content title: "Manage Static Pages" do
    # Here we render a custom form defined in a partial
    render partial: 'admin/static_pages/form'
  end

  # Custom page action to handle form submission
  page_action :save, method: :post do
    # Determine which static page we're editing
    page_name = params[:page_name]

    # Use Rails.root to find the file path
    file_path = Rails.root.join('app', 'views', 'static_pages', "#{page_name}.html.erb")

    # Open the file and write the content to it
    File.open(file_path, 'w') do |file|
      file.write(params[:content])
    end

    # Redirect back to the form with a success message
    redirect_to admin_staticpages_path, notice: "#{page_name} page updated successfully!"
  end
end
