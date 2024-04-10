# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end




# Create Roles
['Admin', 'Moderator'].each do |role_name|
  Role.find_or_create_by!(name: role_name)
end

# Create Tax Rates
5.times do
  TaxRate.create!(
    country: Faker::Address.country,
    state: Faker::Address.state,
    city: Faker::Address.city,
    tax_rate: Faker::Number.between(from: 0.0, to: 9.9).round(1)
  )
end

# Create Brands
50.times do
  Brand.create!(brand_name: Faker::Company.unique.name)
end

# Create Categories
5.times do
  Category.create!(category_name: Faker::Commerce.unique.department(max: 1))
end

# Create Product Types
['Skincare', 'Makeup', 'Haircare', 'Fragrance', 'Tools'].each do |type|
  ProductType.find_or_create_by!(product_type_name: type)
end

# Create Tags
10.times do
  Tag.create!(tag_name: Faker::Commerce.unique.material)
end

# Create Users
10.times do
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    age: rand(18..65),
    gender: Faker::Gender.binary_type,
    password: Faker::Internet.password(min_length: 8),
    default_address: Faker::Address.street_address,
    default_city: Faker::Address.city,
    default_state: Faker::Address.state,
    default_country: Faker::Address.country,
    default_postcode: Faker::Address.zip_code
  )
end

# Create Administrators
3.times do
  Administrator.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: Faker::Internet.password(min_length: 8),
    role_id: Role.order(Arel.sql('RAND()')).first.id
  )
end

# Create Products
100.times do
  # Use specific keywords related to makeup for product names
  makeup_keywords = ['Lipstick', 'Foundation', 'Eyeliner', 'Mascara', 'Blush', 'Eyeshadow', 'Concealer']
  product_name_keyword = makeup_keywords.sample

  product = Product.create!(
    product_name: "#{product_name_keyword} #{Faker::Commerce.color} #{Faker::Commerce.material}",
    brand_id: Brand.order(Arel.sql('RAND()')).first.id,
    price: Faker::Commerce.price(range: 5..100.0),  # Adjust price range if needed
    image_link: "https://loremflickr.com/640/480/#{product_name_keyword.downcase}?lock=#{rand(1..1000)}",
    description: Faker::Lorem.sentence(word_count: 10),
    rating: rand(1.0..5.0).round(1),
    category_id: Category.order(Arel.sql('RAND()')).first.id,
    product_type_id: ProductType.where(product_type_name: 'Makeup').order(Arel.sql('RAND()')).first.id
  )

  # Create ProductTags
  tag_sample = Tag.order(Arel.sql('RAND()')).limit(rand(1..3))
  tag_sample.each do |tag|
    ProductTag.create!(
      product_id: product.id,
      tag_id: tag.id
    )
  end
end

# Create Statuses
['Processing', 'Shipped', 'Delivered'].each do |status_name|
  Status.find_or_create_by!(name: status_name)
end

# Create Orders with Tracking Information
10.times do
  order = Order.create!(
    order_date: Faker::Date.backward(days: 30),
    shipping_address: Faker::Address.street_address,
    shipping_city: Faker::Address.city,
    shipping_state: Faker::Address.state,
    shipping_country: Faker::Address.country,
    shipping_postcode: Faker::Address.zip_code,
    user_id: User.order(Arel.sql('RAND()')).first.id,
    status_id: Status.order(Arel.sql('RAND()')).first.id,
    tax_rate_id: TaxRate.order(Arel.sql('RAND()')).first.id
  )

  # Create tracking information for the order
  Tracking.create!(
    tracking_number: Faker::Number.unique.leading_zero_number(digits: 10),
    order_id: order.id
  )

  # Create associated OrderProducts for the order
  products = Product.order(Arel.sql('RAND()')).limit(rand(1..5))
  products.each do |product|
    OrderProduct.create!(
      order_id: order.id,
      product_id: product.id,
      quantity: rand(1..10),
      price_at_time_of_order: product.price
    )
  end
end

puts 'Seed data successfully populated!'

Administrator.create!(
  name: 'Admin Name',
  email: 'admin@example.com',
  password: 'securepassword', # Ensure this is securely generated or set
  role_id: 1
)