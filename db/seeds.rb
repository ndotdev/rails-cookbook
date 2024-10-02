# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "json"
require "open-uri"

puts "Creating recipes...."

Bookmark.destroy_all
Recipe.destroy_all
Category.destroy_all

# Recipe.create!(
#     name: "Sheet Pan Parmesan Chicken and Veggies",
#     description: "This extra-crispy sheet pan chicken and veggies dinner is baked on one pan and packed with flavor!",
#     image_url: "https://www.allrecipes.com/thmb/86ax9vnYqCJDOlpAnrLVnzQqhjQ=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/274966-sheet-pan-parmesan-chicken-and-veggies-ddmfs-4x3-0155-7cfcf4f7636b452bb8aea50cf1720d8b.jpg",
#     rating: rand(0..10.0).round(1)
# )

# Recipe.create!(
#     name: "Chicken Stir-Fry",
#     description: "This chicken stir-fry recipe is packed with veggies and is quick and easy to prepare. Try adding bean sprouts, bamboo shoots, snap peas, or any of your favorite vegetables. Serve it with white or brown rice, or noodles.",
#     image_url: "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fstatic.onecms.io%2Fwp-content%2Fuploads%2Fsites%2F43%2F2022%2F04%2F29%2F223382_chicken-stir-fry_Rita-1x1-1.jpg&q=60&c=sc&poi=auto&orient=true&h=512",
#     rating: 4.5
# )

# Recipe.create!(
#     name: "Chocolate Chip Muffins",
#     description: "These chocolate chip muffins are quick and easy to make and simply delicious! The tops of these muffins have a crunchy sugar crust for a lovely contrast of texture in each bite.",
#     image_url: "https://www.allrecipes.com/thmb/lS6R_FAR6cqe9XpUN20IcS_WskE=/0x512/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/AR-7906-chocolate-chip-muffins-DDMFS-4x3-69048f49ea934213a0d1a0059b85fd9b.jpg",
#     rating: 4.5
# )

categories = ["Breakfast", "Pasta", "Seafood", "Dessert", "Vegetarian"]

def recipe_builder(id)
    url = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=#{id}"
    meals_serialized = URI.parse(url).read
    meal = JSON.parse(meals_serialized)["meals"][0]
    # p meals["meals"][0]["strMealThumb"]

    Recipe.create!(
        name: meal["strMeal"],
        description: meal["strInstructions"],
        image_url: meal["strMealThumb"],
        rating: rand(1..5.0).round(1)
    )
end

categories.each do |category|
    url = "https://www.themealdb.com/api/json/v1/1/filter.php?c=#{category}"
    recipes_serialized = URI.parse(url).read
    recipes = JSON.parse(recipes_serialized)
    
    recipes["meals"].take(5).each do |recipe|
        recipe_builder(recipe["idMeal"])
    end
    # p recipes
    # puts "Recipe #{recipe} added"
end 

puts "Done! #{Recipe.all.count} recipes created"