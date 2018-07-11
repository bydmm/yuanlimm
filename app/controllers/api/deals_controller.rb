class Api::DealsController < ApplicationController
  before_action :check_log_in, only: [:my]

  def index
    stock = Stock.find(params[:code])
    scope = StockTransaction.where(stock: stock, pay_type: 'trade').order(id: :desc)
    data = scope.limit(5).map do |transaction|
      {
        id: transaction.id,
        amount: transaction.amount,
        price: transaction.buy_order.price,
        created_at: transaction.created_at.rfc2822
      }
    end
    render json: {
      count: scope.count,
      data: data
    }
  end

  def my
    page = params[:page] || 1
    user_id = current_user.id
    scope = Transaction.where('payer_id =? OR payee_id = ?', user_id, user_id)
                       .where(pay_type: 'trade')
                       .order(id: :desc)
    data = scope.page(page).per(100).map do |transaction|
      order = transaction.buy_order || transaction.sale_order
      price = order ? order.price : 0
      {
        id: transaction.id,
        amount: transaction.amount,
        price: price,
        type: transaction.type,
        pay_type: transaction.pay_type,
        payer: {
          id: transaction.payer_id,
          name: transaction.payer.nick_name
        },
        payee: {
          id: transaction.payee_id,
          name: transaction.payee.nick_name
        },
        buy_order_id: transaction.buy_stock_order_id,
        sale_order_id: transaction.sale_stock_order_id,
        stock: transaction.stock.name,
        code: transaction.stock.code,
        created_at: transaction.created_at.rfc2822
      }
    end
    render json: {
      count: scope.count,
      data: data
    }
  end
end
