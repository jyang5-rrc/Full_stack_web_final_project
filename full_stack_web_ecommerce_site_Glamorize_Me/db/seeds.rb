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

# Seed Brands (specifically for makeup)
makeup_brands = ['Maybelline', "L'Oréal", 'MAC', 'NARS', 'Urban Decay']

makeup_brands.each do |brand|
  Brand.find_or_create_by!(brand_name: brand)
end

# Seed Categories (specific to makeup)
makeup_categories = ['Eyes', 'Lips', 'Face', 'Cheeks', 'Brows']
makeup_categories.each do |category|
  Category.find_or_create_by!(category_name: category)
end

# Create Product Types
['Skincare', 'Makeup', 'Haircare', 'Fragrance', 'Tools'].each do |type|
  ProductType.find_or_create_by!(product_type_name: type)
end

# Seed Tags (related to makeup)
makeup_materials = ['Matte', 'Glossy', 'Satin', 'Shimmer', 'Metallic', 'Natural', 'Vegan', 'Hypoallergenic']
makeup_materials.each do |material|
  Tag.find_or_create_by!(tag_name: material)
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

# Seed Products (only makeup related)
20.times do
  makeup_keywords = ['Lipstick', 'Foundation', 'Eyeliner', 'Mascara', 'Blush', 'Eyeshadow', 'Concealer']
  product_name_keyword = makeup_keywords.sample

  product = Product.create!(
    product_name: "#{product_name_keyword} #{Faker::Commerce.color} #{Faker::Commerce.material}",
    brand_id: Brand.where(brand_name: makeup_brands).sample.id,
    price: Faker::Commerce.price(range: 5..100.0),  # Adjust price range if needed
    image_link: "https://loremflickr.com/640/480/#{product_name_keyword.downcase}?lock=#{rand(1..1000)}",
    description: Faker::Lorem.sentence(word_count: 10),
    rating: rand(1.0..5.0).round(1),
    category_id: Category.where(category_name: makeup_categories).sample.id,
    product_type_id: ProductType.find_by(product_type_name: 'Makeup').id
  )

  # Seed ProductTags (specific to makeup)
  tag_sample = Tag.where(tag_name: makeup_materials).sample(rand(1..3))
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

# Create a default admin user
Administrator.create!(
  name: 'Admin Name',
  email: 'admin@example.com',
  password: 'securepassword', # Ensure this is securely generated or set
  role_id: 1
)



# populating data from API
require 'faker'
require 'httparty'
# fetch products from the API
begin
  response = HTTParty.get('http://makeup-api.herokuapp.com/api/v1/products.json')
  products = response.parsed_response if response.code == 200
rescue HTTParty::Error => e
  puts "HTTParty Error: #{e.message}"
rescue StandardError => e
  puts "Standard Error: #{e.message}"
else
  puts "Fetched #{products.size} products from the API."
end

# create or find related records
if products
  # Cache lookups
  brands_cache = {}
  categories_cache = {}
  product_types_cache = {}
  tags_cache = {}

  # Arrays to hold new records for bulk insert
  new_products = []
  new_tags = []
  new_product_tags = []

  products.each do |product_data|

    # find or create brand, category, and product_type
    brands_cache[product_data['brand']] ||= Brand.find_or_create_by(brand_name: product_data['brand'])
    #puts "brands_cache: #{brands_cache.count}, Brand table count: #{Brand.count}"
    categories_cache[product_data['category']] ||= Category.find_or_create_by(category_name: product_data['category'])
    #puts "categories_cache: #{categories_cache.count}, Category table count: #{Category.count}"
    product_types_cache[product_data['product_type']] ||= ProductType.find_or_create_by(product_type_name: product_data['product_type'])
    #puts "product_types_cache: #{product_types_cache.count}, ProductType table count: #{ProductType.count}"

    # Now create the product with FKs to brand, category, and product_type

    if product_data['price'].nil?
      product_data['price'] =Faker::Commerce.price(range: 0..1000, as_string: true)
      # This will generate a random price between 0 and 1000 as a string with a precision of 5 and a scale of 2
      #Replace with FAKER
      puts "Price is nil, replaced with #{product_data['price']}"
    end

    if product_data['description'].nil?
      # Handle the case where the description is nil
      product_data['description'] = Faker::Lorem.sentence
      puts "Description is nil, replaced with #{product_data['description']}"
    end

    if product_data['name'].nil?
      product_data['name'] = Faker::Commerce.product_name
      puts "Name is nil, replaced with #{product_data['name']}"
    end

    if product_data['image_link'].nil?
      product_data['image_link'] = Faker::LoremFlickr.image # "https://loremflickr.com/320/240"
      puts "Image link is nil, replaced with #{product_data['image_link']}"
    end


    if product_data['rating'].nil? || product_data['rating'] >5
      product_data['rating'] = Faker::Number.between(from: 0, to: 5)
      puts "Rating is nil, replaced with #{product_data['rating']}"
    end


    if categories_cache[product_data['category']].id.nil?
      categories_cache[product_data['category']].id = Category.order(Arel.sql('RAND()')).first.id
      puts "Category ID is nil, replaced with #{ categories_cache[product_data['category']].id }"
    end

    if brands_cache[product_data['brand']].id.nil?
      brands_cache[product_data['brand']].id = Brand.order(Arel.sql('RAND()')).first.id
      puts "Brand ID is nil, replaced with #{ brands_cache[product_data['brand']].id }"
    end

  new_product = Product.new(
    product_name: product_data['name'].strip,
    price: product_data['price'],
    image_link: product_data['image_link'].strip,
    description: product_data['description'].strip,
    rating: product_data['rating'],
    brand_id: brands_cache[product_data['brand']].id,
    category_id: categories_cache[product_data['category']].id,
    product_type_id: product_types_cache[product_data['product_type']].id,
  )

  new_products << new_product


    #puts "new_products: #{new_products.count}, Product table count: #{Product.count}"

    # create or find tags and associate with the product
    product_data['tag_list'].each do |tag_name|
      tag_name = tag_name.strip
      tags_cache[tag_name] ||= Tag.find_or_create_by(tag_name: tag_name)

      # Prepare the tag for bulk insert
      new_tags << tags_cache[tag_name] unless new_tags.include?(tags_cache[tag_name])

      # Prepare the product-tag association for bulk insert
      new_product_tags << ProductTag.new(product: new_product, tag: tags_cache[tag_name])

      #puts "new tag: #{tag_name}, new_tags: #{new_tags.count}, Tag table count: #{Tag.count}, new_product_tags: #{new_product_tags.count}, ProductTag table count: #{ProductTag.count}"
    end

  end

  # new_products.each do |product|
  #   puts product.product_name
  # end

  ActiveRecord::Base.transaction do
    # Perform bulk inserts
    Product.import new_products,validate: false
    Tag.import new_tags, on_duplicate_key_ignore: true
    ProductTag.import new_product_tags
  end
  puts "Bulk inserts complete"
end

