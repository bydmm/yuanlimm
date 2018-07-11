class Api::StocksController < ApplicationController
  before_action :check_log_in, only: [:my, :select, :deselect]

  def index
    # expires_in 5.second, public: true
    stock_index = StockIndex.new(params[:sort], params[:keyword], current_user, params[:page])
    scope = stock_index.scope
    render json: {
      count: scope.total_count,
      data: scope.map(&:brief_json)
    }
  end

  def show
    stock = Stock.find(params[:code])
    render json: stock.to_json
  end

  def my
    stock = Stock.find(params[:code])
    render json: {
      balance: current_user.balance,
      stock_balance: current_user.stock_balance(stock),
      wish_count: Transaction.user_count(current_user),
      wish_limit: ENV['WEB_WISH_LIMIT'].to_i,
      selected: SelectedStock.where(user: current_user, stock: stock).present?
    }
  end

  def select
    stock = Stock.find(params[:code])
    SelectedStock.where(user: current_user, stock: stock).destroy_all
    SelectedStock.create(
      user: current_user,
      stock: stock
    )
    render json: { success: true }
  end

  def deselect
    stock = Stock.find(params[:code])
    SelectedStock.where(user: current_user, stock: stock).destroy_all
    render json: { success: true }
  end

  def holding_rank
    stock = Stock.find(params[:code])
    scope = UserStock.where(stock: stock).order(balance: :desc).first(5)
    data = scope.map do |item|
      item.user.hold(stock)
    end
    render json: {
      count: scope.count,
      data: data
    }
  end
end
