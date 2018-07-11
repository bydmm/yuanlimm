class StockTransaction < Transaction
  after_save :change_user_stock
  after_commit :fresh_price, on: :create

  private

  def change_user_stock
    UserStock.add(payee, stock, amount)
    UserStock.minus(payer, stock, amount)
  end

  def fresh_price
    Rails.cache.write("stock:#{stock_code}:price", buy_order.price) if pay_type == 'trade'
  end
end
