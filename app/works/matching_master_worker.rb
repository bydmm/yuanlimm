class MatchingMasterWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'matching'

  def perform(stock_code)
    StockOrder.where(status: 'padding', stock_code: stock_code)
              .where('amount > 0')
              .order(price: :desc, id: :asc)
              .each do |buy_order|
      MatchingSlaveWorker.new.perform(buy_order.id)
    end
  end
end
