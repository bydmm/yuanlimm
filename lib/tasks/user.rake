namespace :user do
  task address: :environment do
    User.all.each do |u|
      u.save
    end
  end
end
