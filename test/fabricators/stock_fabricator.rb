Fabricator(:stock) do
  code Faker::Lorem.characters(10)
  name Faker::Lorem.sentence(3)
  avatar Faker::Internet.url
end
