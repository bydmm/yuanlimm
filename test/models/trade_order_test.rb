
require 'test_helper'

class TradeTest < ActiveSupport::TestCase
  def setup
    @buyer = Fabricate(:user, name: Faker::Lorem.word, nick_name: Faker::Lorem.word)
    @seller = Fabricate(:user, name: Faker::Lorem.word, nick_name: Faker::Lorem.word)
    UserStock.destroy_all
    UserWallet.destroy_all
    @stock = Fabricate(:stock)
  end

  test 'sale stock more than buy stock' do

    multiple = rand(2..5)
    stock_amount = rand(100..200)
    price = rand(100..200)
    volume = stock_amount * price * rand(2..5)
    seller_amount = stock_amount * multiple
    UserStock.add(@seller, @stock, seller_amount)
    UserWallet.add(@buyer, volume)
    buy_order = Fabricate(
      :stock_order,
      stock: @stock,
      amount: stock_amount,
      finished_amount: 10,
      price: price,
      user: @buyer
    )
    sale_order = Fabricate(
      :stock_order,
      stock: @stock,
      amount: -seller_amount,
      price: price,
      user: @seller,
    )
    trade = TradeOrder.new(buy_order.id, sale_order.id)
    assert_difference 'StockTransaction.count', +1 do
      assert_difference 'CoinTransaction.count', +1 do
        trade.match
      end
    end

    buy_order.reload
    sale_order.reload

    assert_equal stock_amount - 10, @buyer.stock_balance(@stock)
    assert_equal (stock_amount - 10) * price, volume - @buyer.balance
    assert_equal @seller.stock_balance(@stock), seller_amount - stock_amount + 10
    assert_equal (stock_amount - 10)* price, @seller.balance
    assert_equal 'success', buy_order.status
    assert_equal 'padding', sale_order.status
  end

  test 'buy stock more than sale stock' do
    stock_amount = rand(100..200)
    price = rand(100..200)
    multiple = rand(2..5)
    volume = stock_amount * price
    fund = volume * multiple
    UserStock.add(@seller, @stock, stock_amount * multiple)
    UserWallet.add(@buyer, fund)
    buy_order = Fabricate(
      :stock_order,
      stock: @stock,
      amount: stock_amount * multiple,
      price: price,
      user: @buyer
    )
    sale_order = Fabricate(
      :stock_order,
      stock: @stock,
      amount: -stock_amount,
      finished_amount: -10,
      price: price,
      user: @seller,
    )
    trade = TradeOrder.new(buy_order.id, sale_order.id)
    assert_difference 'StockTransaction.count', +1 do
      assert_difference 'CoinTransaction.count', +1 do
        trade.match
      end
    end

    buy_order.reload
    sale_order.reload

    assert_equal stock_amount - 10, @buyer.stock_balance(@stock)
    assert_equal @buyer.balance, fund - volume + price * 10
    assert_equal multiple - 1, @seller.stock_balance(@stock) / stock_amount
    assert_equal volume - (price * 10), @seller.balance
    assert_equal 'padding', buy_order.status
    assert_equal 'success', sale_order.status
  end

  test 'trade could made' do
    stock_amount = rand(100..200)
    price = rand(100..200)
    volume = stock_amount * price
    multiple = rand(2..5)
    UserStock.add(@seller, @stock, stock_amount * multiple)
    UserWallet.add(@buyer, volume * multiple)
    buy_order = Fabricate(
      :stock_order,
      stock: @stock,
      amount: stock_amount,
      price: price,
      user: @buyer
    )
    sale_order = Fabricate(
      :stock_order,
      stock: @stock,
      amount: -stock_amount,
      price: price,
      user: @seller,
    )
    trade = TradeOrder.new(buy_order.id, sale_order.id)
    assert_difference 'StockTransaction.count', +1 do
      assert_difference 'CoinTransaction.count', +1 do
        trade.match
      end
    end

    buy_order.reload
    sale_order.reload

    assert_equal stock_amount, @buyer.stock_balance(@stock)
    assert_equal (multiple - 1), @buyer.balance / volume
    assert_equal (multiple - 1), @seller.stock_balance(@stock) / stock_amount
    assert_equal volume, @seller.balance
    assert_equal stock_amount, buy_order.finished_amount
    assert_equal stock_amount, -sale_order.finished_amount
    assert_equal 'success', buy_order.status
    assert_equal 'success', sale_order.status

    transaction = StockTransaction.last
    assert_equal 'trade', transaction.pay_type
    assert_equal @seller, transaction.payer
    assert_equal @buyer, transaction.payee
    assert_equal @stock, transaction.stock
    assert_equal buy_order, transaction.buy_order
    assert_equal sale_order, transaction.sale_order
    assert_equal stock_amount, transaction.amount

    transaction = CoinTransaction.last
    assert_equal 'trade', transaction.pay_type
    assert_equal @buyer, transaction.payer
    assert_equal @seller, transaction.payee
    assert_equal buy_order, transaction.buy_order
    assert_equal sale_order, transaction.sale_order
    assert_equal volume, transaction.amount
  end
end
