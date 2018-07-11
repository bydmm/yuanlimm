class TrendDayWorker
  include Sidekiq::Worker

  sidekiq_options retry: 0

  def perform(stock_code)
    stock = Stock.find(stock_code)
    beginning_of_day = Time.zone.now.beginning_of_day
    return if StockTrend.where(stock: stock, trend_type: 'day_close').where('created_at > ?', beginning_of_day).count > 0
    last_trade = StockTransaction
                 .where(pay_type: 'trade', stock: stock)
                 .where('created_at < ?', beginning_of_day)
                 .order(:id)
                 .last
    return unless last_trade
    StockTrend.create!(
      trend_type: 'day_close',
      stock: stock,
      price: last_trade.buy_order.price,
      datetime: beginning_of_day - 1.second
    )
  end
end
