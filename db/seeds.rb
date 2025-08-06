# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing data
puts "Clearing existing data..."
CartItem.destroy_all
OrderItem.destroy_all
Order.destroy_all
Product.destroy_all
Category.destroy_all
User.destroy_all

# Create Categories
puts "Creating categories..."
electronics = Category.create!(
  name: "Electronics",
  description: "Electronic devices and accessories"
)

clothing = Category.create!(
  name: "Clothing",
  description: "Apparel and fashion items"
)

books = Category.create!(
  name: "Books",
  description: "Books and reading materials"
)

home_garden = Category.create!(
  name: "Home & Garden",
  description: "Home improvement and garden supplies"
)

# Create Users
puts "Creating users..."
john = User.create!(
  email: "john@example.com",
  password: "password123",
  first_name: "John",
  last_name: "Doe"
)

jane = User.create!(
  email: "jane@example.com",
  password: "password123",
  first_name: "Jane",
  last_name: "Smith"
)

# Create Products
puts "Creating products..."

# Electronics
Product.create!([
  {
    name: "iPhone 15",
    description: "Latest Apple smartphone with advanced features",
    price: 999.99,
    inventory_count: 50,
    category: electronics
  },
  {
    name: "Samsung Galaxy S24",
    description: "Powerful Android smartphone",
    price: 899.99,
    inventory_count: 30,
    category: electronics
  },
  {
    name: "MacBook Pro",
    description: "High-performance laptop for professionals",
    price: 1999.99,
    inventory_count: 15,
    category: electronics
  },
  {
    name: "Sony Headphones",
    description: "Noise-canceling wireless headphones",
    price: 299.99,
    inventory_count: 100,
    category: electronics
  }
])

# Clothing
Product.create!([
  {
    name: "Denim Jeans",
    description: "Classic blue denim jeans",
    price: 79.99,
    inventory_count: 200,
    category: clothing
  },
  {
    name: "Cotton T-Shirt",
    description: "Comfortable cotton t-shirt",
    price: 24.99,
    inventory_count: 150,
    category: clothing
  },
  {
    name: "Leather Jacket",
    description: "Premium leather jacket",
    price: 199.99,
    inventory_count: 25,
    category: clothing
  },
  {
    name: "Running Shoes",
    description: "Comfortable running shoes",
    price: 129.99,
    inventory_count: 80,
    category: clothing
  }
])

# Books
Product.create!([
  {
    name: "The Great Gatsby",
    description: "Classic American novel by F. Scott Fitzgerald",
    price: 12.99,
    inventory_count: 500,
    category: books
  },
  {
    name: "To Kill a Mockingbird",
    description: "Pulitzer Prize-winning novel by Harper Lee",
    price: 14.99,
    inventory_count: 300,
    category: books
  },
  {
    name: "Programming Ruby",
    description: "Comprehensive guide to Ruby programming",
    price: 49.99,
    inventory_count: 75,
    category: books
  }
])

# Home & Garden
Product.create!([
  {
    name: "Garden Hose",
    description: "50ft expandable garden hose",
    price: 39.99,
    inventory_count: 60,
    category: home_garden
  },
  {
    name: "Plant Pot Set",
    description: "Set of 5 ceramic plant pots",
    price: 29.99,
    inventory_count: 40,
    category: home_garden
  },
  {
    name: "LED Light Bulbs",
    description: "Energy-efficient LED bulbs (4-pack)",
    price: 19.99,
    inventory_count: 200,
    category: home_garden
  }
])

# Create some cart items
puts "Creating cart items..."
iphone = Product.find_by(name: "iPhone 15")
jeans = Product.find_by(name: "Denim Jeans")
headphones = Product.find_by(name: "Sony Headphones")

CartItem.create!([
  {
    user: john,
    product: iphone,
    quantity: 1
  },
  {
    user: john,
    product: headphones,
    quantity: 2
  },
  {
    user: jane,
    product: jeans,
    quantity: 1
  }
])

# Create some sample orders
puts "Creating sample orders..."
order1 = Order.new(
  user: john,
  status: 'confirmed',
  order_date: 1.week.ago
)

# Add order items first
order_items = [
  {
    product: Product.find_by(name: "Cotton T-Shirt"),
    quantity: 2,
    unit_price: 24.99
  },
  {
    product: Product.find_by(name: "The Great Gatsby"),
    quantity: 1,
    unit_price: 12.99
  }
]

order_items.each do |item_data|
  order1.order_items.build(
    product: item_data[:product],
    quantity: item_data[:quantity],
    unit_price: item_data[:unit_price]
  )
end

# Now save the order (total will be calculated automatically)
order1.save!

puts "Seed data created successfully!"
puts "Categories: #{Category.count}"
puts "Products: #{Product.count}"
puts "Users: #{User.count}"
puts "Cart Items: #{CartItem.count}"
puts "Orders: #{Order.count}"
puts "Order Items: #{OrderItem.count}"
