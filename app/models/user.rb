class User < ApplicationRecord
  require './lib/string'

  has_secure_password

  has_many :orders, class_name: 'StockOrder', dependent: :destroy
  has_many :user_stocks, dependent: :destroy
  has_one :user_wallet, dependent: :destroy

  validates :name, uniqueness: true, presence: true
  validates :nick_name, uniqueness: true, presence: true
  validates :password, presence: true, length: { in: 6..20 }, on: :create
  validates :password_confirmation, presence: true, on: :create

  before_save :generate_token, :generate_address
  after_create :welfare

  def to_json
    {
      id: id,
      name: name,
      nick_name: nick_name,
      balance: balance,
      address: address,
      wish_count: Transaction.user_count(self),
      wish_limit: ENV['WEB_WISH_LIMIT'].to_i
    }
  end

  def love(stock, detail, hard, rand_stock = true)
    case rand(1..100)
    when 90..100
      pay_stock(stock, detail, pay_stock_amount(hard))
    when 60..90
      if rand_stock
        stock = Stock.order('RAND()').last
        detail.reject! { |k| k == :cheer_word }
      end
      pay_stock(stock, detail, pay_stock_amount(hard))
    else
      pay_coin(stock, detail, pay_coin_amount(hard))
    end
  end

  def balance
    UserWallet.find_or_create_by(user: self).balance
  end

  def stock_balance(stock)
    UserStock.find_and_create(self, stock).balance
  end

  def shareholding_ratio(stock)
    ((stock_balance(stock) / stock.total_share.to_f) * 100.0).round(2)
  end

  def cheer_word(stock)
    Rails.cache.fetch("user:#{id}:stock#{stock.code}:cheer_word", expires_in: 3.minutes) do
      cheer_word = ''
      transcations = StockTransaction.where(stock: stock, pay_type: 'love', payee: self)
                                     .order(id: :desc)
      transcations.select do |transcation|
        cheer_word = transcation.detail[:cheer_word]
        break
      end
      cheer_word
    end
  end

  def hold(stock)
    {
      id: id,
      user: nick_name,
      balance: stock_balance(stock),
      cheer_word: cheer_word(stock),
      shareholding_ratio: shareholding_ratio(stock)
    }
  end

  def pay_stock(stock, detail, stock_amount, type = 'love')
    StockTransaction.new(
      payer_id: 0,
      payee_id: id,
      stock: stock,
      pay_type: type,
      amount: stock_amount,
      detail: detail
    )
  end

  def pay_coin(stock, detail, coin_amount, type = 'love')
    CoinTransaction.new(
      payer_id: 0,
      payee_id: id,
      stock: stock,
      pay_type: type,
      amount: coin_amount,
      detail: detail
    )
  end

  private

  def hard_addition(hard)
    addition = (hard - ENV['HARD'].to_i) / 2
    addition > 0 ? addition : 1
  end

  def pay_stock_amount(hard)
    case rand(1..1000)
    when 995..1000
      233 * hard_addition(hard)
    else
      rand(1..5) * hard_addition(hard)
    end
  end

  def pay_coin_amount(hard)
    case rand(1..1000)
    when 995..1000
      233_000 * hard_addition(hard)
    else
      rand(1_000..10_000) * hard_addition(hard)
    end
  end

  def welfare
    return true if Rails.env.test?
    Stock.order('RAND()').limit(5).each do |stock|
      UserStock.add(self, stock, 500)
    end
    UserWallet.add(self, 1_000_000)
  end

  def generate_token
    self.token = String.random if token.blank?
  end

  def generate_address
    self.address = String.random(34) if address.blank?
  end
end
