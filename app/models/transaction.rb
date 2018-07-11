class Transaction < ApplicationRecord
  enum pay_type: %i[love trade give]
  serialize :detail, Hash

  belongs_to :buy_order, class_name: 'StockOrder', foreign_key: :buy_stock_order_id, optional: true
  belongs_to :sale_order, class_name: 'StockOrder', foreign_key: :sale_stock_order_id, optional: true
  belongs_to :payer, class_name: 'User', foreign_key: :payer_id, optional: true
  belongs_to :payee, class_name: 'User', foreign_key: :payee_id, optional: true
  belongs_to :stock, foreign_key: :stock_code

  validates  :amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  def self.global_key
    'global:wishs:count'
  end

  def self.global_hard_key
    'global:hard'
  end

  def self.last_global_hard_key
    'global:hard:count:last'
  end

  def self.user_count(user)
    key = "user:#{user.id}:wishs:count"
    count = $redis.get(key).to_i
    if count.zero?
      $redis.set(key, 0, ex: (Time.zone.now.end_of_day.to_i - Time.zone.now.to_i))
    end
    count
  end

  def self.global_count
    Rails.cache.fetch(global_key, expires_in: 2.minutes) do
      Transaction.where(pay_type: 'love')
                 .where('created_at > ?', Time.now - 2.minutes)
                 .count
    end.to_i
  end

  def self.global_hard
    hard = $redis.get(global_hard_key).to_i
    if hard.zero?
      base_hard = 24
      hard = ($redis.get(last_global_hard_key) || base_hard).to_i
      if global_count > 200
        hard += 1
      else
        hard -= 1
      end
      hard = base_hard if hard < base_hard
      $redis.set(global_hard_key, hard, ex: 2.minutes.to_i)
      $redis.set(last_global_hard_key, hard)
    end
    hard
  end
end
