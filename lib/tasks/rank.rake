namespace :rank do
  task user: :environment do
    UserRankWorker.perform_async
  end

  task hot: :environment do
    HotRankWorker.perform_async
  end

  task market_value: :environment do
    MarketValueRankWorker.perform_async
  end

  task buy_price: :environment do
    BuyPriceRankWorker.perform_async
  end

  task sale_price: :environment do
    SalePriceRankWorker.perform_async
  end

  task clear: :environment do
  end
end
