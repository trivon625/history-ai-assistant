# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Topic.destroy_all

puts "🌱 seeding 3 topics..."

# Seed the 3 topics
Topic.create!([
  {
    title: "The French Revolution",
    description: "Explore the causes, key events, and consequences of the French Revolution (1789–1799) — one of the most dramatic political upheavals in history.",
    ai_instructions: "You are a friendly history tutor helping secondary school students understand the French Revolution. Keep your explanations simple, clear and engaging. Avoid overly academic language. Use examples and analogies where possible. Focus on the period 1789–1799."
  },
  {
    title: "World War I",
    description: "Discover the origins, major battles, and lasting impact of the First World War (1914–1918) that reshaped the entire world.",
    ai_instructions: "You are a friendly history tutor helping secondary school students understand World War I. Keep your explanations simple, clear and engaging. Avoid overly academic language. Use examples and analogies where possible. Focus on the period 1914–1918."
  },
  {
    title: "The Roman Empire",
    description: "Journey through the rise and fall of one of the greatest empires in history — from Julius Caesar to the collapse of Rome.",
    ai_instructions: "You are a friendly history tutor helping secondary school students understand the Roman Empire. Keep your explanations simple, clear and engaging. Avoid overly academic language. Use examples and analogies where possible. Focus on the period from 27 BC to 476 AD."
  }
])

puts "✅ Seeded #{Topic.count} topics!"
