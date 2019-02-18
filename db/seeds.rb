User.create!(name: "Maia Coghlan",
  email: "mccog@hotmail.com.au",
  password: "password",
  password_confirmation: "password",
  admin: true,
  activated: true,
  activated_at: Time.zone.now)

User.create!(name: "Example User",
              email: "example@railstutorial.org",
              password: "password",
              password_confirmation: "password",
              activated: true,
              activated_at: Time.zone.now)

99.times do |n|
  name = Faker::FunnyName.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
                email: email,
                password: password,
                password_confirmation: password,
                activated: true,
                activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
50.times do |n|
  users.each { |user| user.posts.create!(content: Faker::GreekPhilosophers.quote, created_at: n.days.ago) }
end

us = User.all
u  = us.first
following = us[2..50]
followers = us[3..40]
following.each { |followed| u.follow(followed) }
followers.each { |follower| follower.follow(u) }