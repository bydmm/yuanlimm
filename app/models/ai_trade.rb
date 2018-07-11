class AiTrade
  def self.give_stock(user, stock, amount)
    return if user.stock_balance(stock) >= amount
    user.pay_stock(stock, {}, amount, 'give').save
  end

  def self.give_coin(user, stock, amount)
    return if user.balance >= amount
    user.pay_coin(stock, {}, amount, 'give').save
  end

  def self.run
    Stock.all.each do |stock|
      MatchingMasterWorker.perform_async(stock.code)
      buy_order = StockOrder.where(status: 'padding', stock: stock).where('amount > 0').order(price: :desc).first
      sell_order = StockOrder.where(status: 'padding', stock: stock).where('amount < 0').order(:price).first
      next if buy_order && sell_order && buy_order.price >= sell_order.price
      demos = User.where(demo: true).order('RAND()').limit(2)
      u1 = demos.first
      u2 = demos.last

      user = nil
      price = 0
      amount = 0
      if buy_order
        user = buy_order.user.id != u1.id ? u1 : u2
        amount = (buy_order.amount.abs * rand(0.0..1.0)).to_i
        amount = amount < 100 ? 100 : amount
        give_stock(user, stock, amount)
        price = (buy_order.price * rand(0.9..1.1)).to_i
        amount = -amount.abs
      elsif sell_order
        user = sell_order.user.id != u1.id ? u1 : u2
        amount = (sell_order.amount.abs * rand(0.0..1.0)).to_i
        amount = amount < 100 ? 100 : amount
        give_coin(user, stock, amount * sell_order.price)
        price = (sell_order.price * rand(0.9..1.1)).to_i
        amount = amount.abs
      else
        user = rand(100) < 50 ? u1 : u2
        price = (stock.price * rand(0.9..1.1)).to_i
        price = 10 * 100 if price.zero?

        if rand(100) < 50
          amount = (100 * rand(1.0..2.0)).to_i
          give_coin(user, stock, amount * price)
        else
          amount = -(100 * rand(1.0..2.0)).to_i
          give_stock(user, stock, amount)
        end
      end
      price = price < 100 ? 100 : price
      params = {
        'code' => stock.code,
        'price' => price,
        'amount' => amount,
        'detail' => {}
      }
      order_form = OrderForm.new(params, user)
      unless order_form.valid?
        puts order_form.errors.full_messages
      end
      next unless order_form && order_form.valid?
      order_form.submit
      MatchingMasterWorker.perform_async(stock.code)
    end
  end
end
