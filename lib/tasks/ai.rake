namespace :ai do
  task demo: :environment do
    require './lib/string'
    # User.where('name like ?', 'test%').destroy_all
    User.where(demo: true).destroy_all
    File.open('lib/resource/faker.txt', 'r') do |f|
      f.each_line do |line|
        name = String.random(14)
        password = String.random(14)
        User.create(
          name: name,
          nick_name: line,
          password: password,
          password_confirmation: password,
          demo: true
        )
      end
    end
  end

  task trade: :environment do
    AiTrade.run
  end
end
