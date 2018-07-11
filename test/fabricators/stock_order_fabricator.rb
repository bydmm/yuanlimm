Fabricator(:stock_order) do
  detail do
    { reason: Faker::Lorem.sentence(3) }
  end
  status 'padding'
end
