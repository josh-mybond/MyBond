# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


role     = 100 # admin
password = "MyBondAg3"

User::create_user!(
  first_name: "Matt",
  last_name: "Stone",
  email: "matt@mybond.com.au",
  role: role,
  password: password,
  password_confirmation: password,
  confirmed_at: DateTime.now
)

User::create_user!(
  first_name: "Joshua",
  last_name: "Theeuf",
  email: "josh@mybond.com.au",
  role: role,
  password: password,
  password_confirmation: password,
  confirmed_at: DateTime.now
)
