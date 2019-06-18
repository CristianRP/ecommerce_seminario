# frozen_string_literal: true

after :categories, :characteristics do
  faker = Faker::Commerce
  50.times do
    category = Category.find(rand(1..4))
    characteristic = Characteristic.find(rand(1..9))
    price = faker.price
    Product.create(description: faker.product_name, sku: rand(100..999),
                   category: category, active: true, quantity: rand(2..10), price: price,
                   cost: price * 2, characteristic: characteristic)
  end
end
