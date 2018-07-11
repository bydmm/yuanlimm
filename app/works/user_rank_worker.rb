class UserRankWorker
  include Sidekiq::Worker

  def perform
    ranks =
      User.where.not(id: 1).map do |u|
        capital = 0
        holdings = UserStock.where(user: u).where('balance > 0').order(balance: :desc)
        holdings.each do |hold|
          capital += hold.stock.price * hold.balance
        end
        true_love_stock = holdings.first ? holdings.first.stock.code : ''
        {
          id: u.id,
          capital: capital,
          true_love_stock: true_love_stock
        }
      end
    ranks = ranks.sort! { |x, y| y[:capital] <=> x[:capital] }.first(50)
    Rails.cache.write('user_rank_list', ranks)
  end
end
