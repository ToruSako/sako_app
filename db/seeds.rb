User.create!(
  name: "Toru Sako",
  email: "majikade.zou@gmail.com",
  password: "foobar",
  password_confirmation: "foobar",
  activated: true,
  admin: true
)

5.times do |n|
  name = Faker::Name.name
  email = "example_#{n+1}@railstutorial.org"
  password = "password"
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true
  )
end

users = User.order(:created_at).take(3)
50.times do
  memo = Faker::Lorem.sentence(6)
  users.each { |user| user.microposts.create!(memo: memo) }
end
