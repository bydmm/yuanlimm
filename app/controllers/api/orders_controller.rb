class Api::OrdersController < ApplicationController
  before_action :check_log_in, only: [:create, :cancel, :my]

  def index
    type = params[:type] || 'sale'
    status = params[:status] || 'padding'
    stock = Stock.find(params[:code])
    scope = StockOrder.where(stock: stock, status: status)
    scope =
      if type == 'sale'
        scope.where('amount < 0').order(:price)
      else
        scope.where('amount > 0').order(price: :desc)
      end
    data = scope.limit(5).map do |order|
      {
        id: order.id,
        user: order.user.to_json,
        price: order.price,
        amount: order.amount,
        finished_amount: order.finished_amount,
        detail: order.detail,
        status: order.status,
        created_at: order.created_at.rfc2822
      }
    end
    render json: {
      count: scope.count,
      data: data
    }
  end

  def create
    order_form = OrderForm.new(permit_params, current_user)
    unless order_form.valid?
      render json: {
        error: true,
        msg: order_form.errors.full_messages.join(', ')
      }
      return
    end
    if order_form.submit
      render json: {
        success: true,
        msg: '挂单成功'
      }.to_json
    else
      render json: {
        error: true,
        msg: order_form.order.errors.full_messages.join(', ')
      }
    end
  end

  def my
    my_orders = MyOrders.new(params[:code], params[:status], params[:page], current_user)
    scope = my_orders.scope
    data = scope.map do |order|
      {
        id: order.id,
        price: order.price,
        amount: order.amount,
        detail: order.detail,
        code: order.stock_code,
        stock: order.stock.name,
        status: order.status,
        finished_amount: order.finished_amount,
        created_at: order.created_at.rfc2822
      }
    end
    render json: {
      count: scope.total_count,
      data: data
    }
  end

  def cancel
    order = current_user.orders.find(params[:id])
    order.with_lock do
      if order.status == 'padding'
        order.status = 'cancel'
        order.save!
      end
    end
    render json: {
      success: true
    }
  end

  private

  def permit_params
    params.permit!
  end
end
