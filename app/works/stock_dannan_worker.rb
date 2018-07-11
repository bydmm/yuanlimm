class StockDannanWorker
  include Sidekiq::Worker

  def perform(stock_code)
    new_dannan = UserStock.where(stock_code: stock_code).order(balance: :desc).first
    return unless new_dannan
    old_dannan = StockDannan.where(stock_code: stock_code).order(:id).last
    return if old_dannan && old_dannan.user_id == new_dannan.user_id
    StockDannan.create!(
      stock_code: stock_code,
      user_id: new_dannan.user_id
    )
  end
end
