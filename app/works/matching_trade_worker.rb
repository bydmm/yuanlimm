class MatchingTradeWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'matching'

  sidekiq_options retry: 0

  def perform(buy_order_id, sale_order_id)
    tade = TradeOrder.new(buy_order_id, sale_order_id)
    tade.match
  end
end
