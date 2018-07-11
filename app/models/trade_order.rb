
# 撮合买交易
class TradeOrder
  attr_reader :order_id

  def initialize(buy_order_id, sale_order_id)
    @buy_order_id = buy_order_id
    @sale_order_id = sale_order_id
  end

  def buy_order
    @buy_order ||= StockOrder.find_by(id: @buy_order_id)
  end

  def sale_order
    @sale_order ||= StockOrder.find_by(id: @sale_order_id)
  end

  def buyer
    buy_order.user
  end

  def seller
    sale_order.user
  end

  def total_fund
    wallet = UserWallet.find_by(user: buyer)
    wallet.balance
  end

  def deal_price
    buy_order.price
  end

  def total_stock
    user_stock = UserStock.find_by(user: seller, stock: sale_order.stock)
    user_stock.balance
  end

  def sale_amount
    want_sale = sale_order.amount.abs - sale_order.finished_amount.abs
    if total_stock <= want_sale
      total_stock
    else
      want_sale
    end
  end

  def buy_amount
    want_buy = buy_order.amount - buy_order.finished_amount
    max_buy_amount = total_fund / deal_price
    if max_buy_amount <= want_buy
      max_buy_amount
    else
      want_buy
    end
  end

  # 这里有四种情况
  def deal_stock_amount
    return @deal_stock_amount if @deal_stock_amount
    @deal_stock_amount =
      if buy_amount >= sale_amount
        sale_amount
      else
        buy_amount
      end
  end

  # 一手交钱
  def transfer_coin(buyer, seller, amount)
    CoinTransaction.create!(
      payer: buyer,
      payee: seller,
      amount: amount,
      stock: buy_order.stock,
      buy_order: buy_order,
      sale_order: sale_order,
      pay_type: 'trade'
    )
  end

  # 一手交货
  def transfer_stock(buyer, seller, amount)
    StockTransaction.create!(
      payer: seller,
      payee: buyer,
      amount: amount,
      stock: buy_order.stock,
      buy_order: buy_order,
      sale_order: sale_order,
      pay_type: 'trade'
    )
  end

  # 撮合交易
  def match
    auto_cancel
    return false unless valid?
    StockOrder.transaction do
      # 一手交钱，一手交货
      # puts "deal_stock_amount: #{deal_stock_amount}"
      pay = deal_stock_amount * deal_price
      transfer_coin(buyer, seller, pay)
      transfer_stock(buyer, seller, deal_stock_amount)
      # 处理
      buy_order.finished_amount = buy_order.finished_amount + deal_stock_amount
      buy_order.save!
      sale_order.finished_amount = sale_order.finished_amount - deal_stock_amount
      sale_order.save!
    end
  end

  def valid?
    buy_order_valid? && sale_order_valid? && deal_stock_amount > 0
  end

  def auto_cancel
    if deal_price > total_fund
      buy_order.update!(status: 'cancel')
    end
    if total_stock < 1
      sale_order.update!(status: 'cancel')
    end
  end

  def buy_order_valid?
    return false if buy_order.status != 'padding'
    return false if buy_order.amount.zero? || buy_order.price.zero?
    return false if buy_order.amount < 0
    true
  end

  def sale_order_valid?
    return false if sale_order.status != 'padding'
    return false if sale_order.amount.zero? || sale_order.price.zero?
    return false if sale_order.amount > 0
    true
  end
end
