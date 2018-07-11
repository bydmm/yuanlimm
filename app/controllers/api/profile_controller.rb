class Api::ProfileController < ApplicationController
  before_action :check_log_in, only: [:show]

  def show
    capital = 0
    holdings = UserStock.where(user: current_user).where('balance > 0').order(balance: :desc)
    data = holdings.map do |hold|
      capital += hold.stock.price * hold.balance
      {
        code: hold.stock_code,
        name: hold.stock.name,
        balance: hold.balance,
        price: hold.stock.price,
        shareholding_ratio: current_user.shareholding_ratio(hold.stock)
      }
    end
    render json: {
      coin_balance: current_user.balance,
      stocks: data,
      capital: capital + current_user.balance
    }
  end
end
