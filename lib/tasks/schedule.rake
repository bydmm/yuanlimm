task schedule: :environment do
  puts '启动定时任务'
  Stock.all.each do |stock|
    TrendHourWorker.perform_async(stock.code)
    TrendDayWorker.perform_async(stock.code)
  end
end

task dannan_check: :environment do
  puts '启动老公检查'
  Stock.all.each do |stock|
    StockDannanWorker.perform_async(stock.code)
  end
end
