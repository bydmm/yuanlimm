Fabricator(:user) do
  name Faker::Lorem.characters(15)
  nick_name Faker::Lorem.characters(15)
  password '123456'
  password_confirmation '123456'
end
