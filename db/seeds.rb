# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

## Create a dummy user
user = User.create!(first_name: "gang", last_name: "chen", password: "123", password_confirmation:"123",
	email: 'gche8512@gmail.com', bio: " The worst programmer",
	username: 'gangc001')

