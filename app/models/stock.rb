class Stock < ApplicationRecord
  self.primary_key = 'code'

  serialize :tags, Array

  validates :name, uniqueness: true, presence: true
  validates :code, presence: true, length: { in: 2..20 }

  after_save :create_index

  def price_day_open
    trend = StockTrend.where(stock: self, trend_type: 'day_close')
                      .order(:id)
                      .last
    if trend
      trend.price
    else
      0
    end
  end

  def price
    Rails.cache.fetch("stock:#{code}:price") do
      trade = StockTransaction.where(pay_type: 'trade', stock: self).order(:id).last
      if trade
        trade.buy_order.price
      else
        0
      end
    end
  end

  def total_share
    scope = UserStock.select('sum(balance) as sum').where(stock: self).first
    if scope
      scope.sum
    else
      0
    end
  end

  def current_danna
    dannan = StockDannan.where(stock: self).order(:id).last
    return unless dannan
    {
      id: dannan.user_id,
      user: dannan.user.nick_name,
      balance: dannan.user.stock_balance(self),
      cheer_word: dannan.user.cheer_word(self),
      shareholding_ratio: dannan.user.shareholding_ratio(self),
      created_at: dannan.created_at.rfc2822
    }
  end

  def brief_json
    {
      name: name,
      code: code,
      avatar: avatar,
      video_link: video_link,
      price: price,
      price_day_open: price_day_open
    }
  end

  def to_json
    {
      name: name,
      code: code,
      avatar: avatar,
      video_link: video_link,
      music_link: music_link,
      tags: tags,
      price: price,
      current_danna: current_danna,
      price_day_open: price_day_open,
      total_share: total_share
    }
  end

  def create_index
    if name_changed? || code_changed? || tags_changed?
      SearchWorker.perform_async(code)
    end
  end
end
