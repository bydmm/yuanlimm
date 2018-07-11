class TrendHourWorker
  include Sidekiq::Worker

  sidekiq_options retry: 0

  def perform(stock_code)
    stock = Stock.find(stock_code)
    beginning_of_hour = Time.zone.now.beginning_of_hour
    return if StockTrend.where(stock: stock, trend_type: 'hour_close').where('created_at > ?', beginning_of_hour).count > 0
    last_trade = StockTransaction
                 .where(pay_type: 'trade', stock: stock)
                 .where('created_at < ?', beginning_of_hour)
                 .order(:id)
                 .last
    return unless last_trade
    StockTrend.create!(
      trend_type: 'hour_close',
      stock: stock,
      price: last_trade.buy_order.price,
      datetime: beginning_of_hour - 1.second
    )
  end
end
