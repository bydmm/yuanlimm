class SalePriceRankWorker
  include Sidekiq::Worker

  def perform
    Stock.all.each do |stock|
      order =
        StockOrder.where(status: 'padding', stock: stock)
                  .where('amount < 0')
                  .order(:price)
                  .first
      stock.sale_price = order.present? ? order.price : 0
      stock.save
    end
  end
end
