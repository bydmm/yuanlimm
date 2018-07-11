class StockTrend < ApplicationRecord
  enum trend_type: %i[day_close day_avg hour_close hour_avg]

  belongs_to :stock, foreign_key: :stock_code

  validates  :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 100 }
  validates  :datetime, presence: true
end
