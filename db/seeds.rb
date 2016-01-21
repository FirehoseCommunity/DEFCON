# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Create Users
# Example: User.create([{first_name: "", last_name: "", email: "", password: "", password_confirmation: "", admin: [true/false] }])

User.create([
  {first_name: "Awesome", last_name: "Admin", email: "asmadmn@example.com", password: "password", password_confirmation: "password", admin: true},
  {first_name: "Awesome", last_name: "User", email: "asmusr@example.com", password: "password", password_confirmation: "password"},
  {first_name: "User", last_name: "Maximus", email: "maxusr@example.com", password: "password", password_confirmation: "password"}
  ])

# Create Posts
# Example: Post.create([{title: "", body: "", user_id: 0}])

Post.create([
  {title: "Lights", body: "First Post", user_id: 1},
  {title: "Camera", body: "Second Post", user_id: 2},
  {title: "Action!", body: "Third Post", user_id: 3}
  ])

# Create Comments
# Example: Comment.create([{message: "", user_id: 0, post_id: 0}])

Comment.create([
  {message: "In the spotlight", user_id: 2, post_id: 1},
  {message: "I'm ready for my close-up", user_id: 3, post_id: 2},
  {message: "Action-Packed online chess tournament", user_id: 1, post_id: 3}
  ])