class OrderForm
  include ActiveModel::Model

  attr_reader :user

  validates :code, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 100 }
  validates :amount, presence: true
  validate  :stock_presence,
            :order_limit,
            :amount_not_zero,
            :amount_lower_limit,
            :enough_money,
            :enough_stock

  def initialize(other_payload, other_user)
    @payload = other_payload
    @user = other_user
  end

  def code
    @payload['code']
  end

  def stock
    @stock ||= Stock.find_by(code: code)
  end

  def price
    @payload['price']
  end

  def amount
    @payload['amount']
  end

  def detail
    @payload['detail'].to_h
  end

  def order
    @order ||= StockOrder.new(
      user: user,
      stock: stock,
      price: price,
      amount: amount,
      detail: detail,
      status: 'padding'
    )
  end

  def submit
    order.save
  end

  private

  def stock_presence
    errors.add(:code, :not_exist) unless stock
  end

  def order_limit
    # if StockOrder.where(user: user, status: 'padding').count > 10
    #   errors.add(:base, :total_order_limit)
    # end
    if StockOrder.where(user: user, status: 'padding', stock: stock).count > 5
      errors.add(:base, :single_order_limit)
    end
  end

  def amount_not_zero
    errors.add(:amount, :not_equal_zero) if amount.zero?
  end

  def amount_lower_limit
    errors.add(:amount, :amount_lower_limit) if amount.abs < 100
  end

  def enough_money
    errors.add(:base, :not_enough_blance) if amount > 0 && user.balance < (price * amount)
  end

  def enough_stock
    errors.add(:base, :not_enough_stock) if amount < 0 && user.stock_balance(stock) < amount.abs
  end
end
