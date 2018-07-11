namespace :trend do
  task clear: :environment do
    StockTrend.destroy_all
  end

  task review: :environment do
    check = 0
    finish = 0
    Stock.all.each do |stock|
      for i in 0..240
        check += 1
        time = Time.zone.now.beginning_of_hour
        from = time - (i + 1).hours
        to = time - i.hours
        last_trade = StockTransaction
                     .where(pay_type: 'trade', stock: stock)
                     .where('created_at >= ? && created_at < ?', from, to)
                     .order(:id)
                     .last
        unless last_trade
          next
        end
        StockTrend.create!(
          trend_type: 'hour_close',
          stock: stock,
          price: last_trade.buy_order.price,
          datetime: from
        )
        finish += 1
        print "#{finish}:#{check}\r"
      end
      for i in 0..30
        time = Time.zone.now.beginning_of_day
        from = time - (i + 1).days
        to = time - i.days
        last_trend = StockTrend
                     .where(trend_type: 'hour_close', stock: stock)
                     .where('datetime >= ? && datetime < ?', from, to)
                     .order(:id)
                     .last
        unless last_trend
          next
        end
        StockTrend.create!(
          trend_type: 'day_close',
          stock: stock,
          price: last_trend.price,
          datetime: from
        )
      end
    end
  end
end
