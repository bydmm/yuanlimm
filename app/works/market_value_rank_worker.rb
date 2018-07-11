class MarketValueRankWorker
  include Sidekiq::Worker

  def perform
    Stock.all.each do |stock|
      stock.market_value = stock.price * stock.total_share
      stock.save
    end
  end
end
