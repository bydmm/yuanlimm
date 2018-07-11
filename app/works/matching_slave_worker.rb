class MatchingSlaveWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'matching'
  sidekiq_options retry: false

  def perform(buy_order_id)
    buy_order = StockOrder.find(buy_order_id)
    sale_orders(buy_order).each do |sale_order|
      MatchingTradeWorker.new.perform(buy_order_id, sale_order.id)
    end
  end

  def sale_orders(buy_order)
    # 不买自己的卖单
    StockOrder.where(status: 'padding', stock: buy_order.stock)
              .where('price <= ?', buy_order.price)
              .where.not(user: buy_order.user)
              .order(:id)
  end
end
