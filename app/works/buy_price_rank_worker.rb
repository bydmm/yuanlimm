class BuyPriceRankWorker
  include Sidekiq::Worker

  def perform
    Stock.all.each do |stock|
      order =
        StockOrder.where(status: 'padding', stock: stock)
                  .where('amount > 0')
                  .order(:price)
                  .last
      stock.buy_price = order.present? ? order.price : 0
      stock.save
    end
  end
end
