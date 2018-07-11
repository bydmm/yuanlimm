namespace :order do
  task matching: :environment do
    Stock.all.each do |stock|
      MatchingMasterWorker.perform_async(stock.code)
    end
  end

  task clear: :environment do
    StockOrder.destroy_all
  end

  task match: :environment do
    MatchingMasterWorker.perform_async
  end
end
