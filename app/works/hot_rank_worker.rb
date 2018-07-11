class HotRankWorker
  include Sidekiq::Worker

  def perform
    scope = Transaction.select('COUNT(*) as hot, stock_code')
                       .where('created_at > ?', Time.now - 10.minutes)
                       .group(:stock_code)
                       .order('hot DESC')
    stocks = scope.map do |item|
      stock = Stock.find(item.stock_code)
      time = (Time.now - stock.created_at).to_i / (24 * 60 * 60)
      hot = item.hot / ((time + 2)**1.8)
      {
        stock: stock.code,
        hot: hot
      }
    end
    stocks.sort! { |x, y| y[:hot] <=> x[:hot] }
    stocks.each_with_index do |item, index|
      stock = Stock.find(item[:stock])
      stock.order = index
      stock.save
    end
  end
end
