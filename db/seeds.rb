# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create({name: "root", password: "root@123", password_confirmation: "root@123", email: "root@sample.com", role: :admin})
User.create({name: "liteng", password: "liteng@123", password_confirmation: "liteng@123", email: "liteng@sample.com", role: :operator})

100.times do |i|
  u = User.create({name: "user#{i}",
                   password: "user#{i}@123",
                   password_confirmation: "user#{i}@123",
                   email: "user#{i}@sample.com",
                   role: :user,
                   telephone: "#{10000000000 + i}"})
end