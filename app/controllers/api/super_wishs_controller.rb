class Api::SuperWishsController < ApplicationController
  before_action :check_log_in, only: [:create]

  def index
    expires_in 5.second, public: true
    render json: {
      unix_time: Time.now.beginning_of_minute.to_i,
      hard: Transaction.global_hard
    }
  end

  def create
    hard = Transaction.global_hard
    unless love?(params[:cheer_word], params[:address], params[:code], params[:love_power], hard)
      render json: { success: false, msg: '应援失败，再接再厉！', hard: hard }
      return
    end
    stock = Stock.find(params[:code])
    detail = { cheer_word: params[:cheer_word], love_power: params[:love_power] }
    transaction = current_user.love(stock, detail, hard)
    if transaction.save
      type =
        case transaction.type
        when 'CoinTransaction'
          'coin'
        when 'StockTransaction'
          'stock'
        end
      render json: {
        success: true,
        hard: Transaction.global_hard,
        type: type,
        amount: transaction.amount,
        stock: transaction.stock_code
      }
    else
      render json: { success: false, msg: transaction.errors.full_messages.join(', ') }
    end
  end

  private

  def current_user
    @current_user ||= User.find_by(address: params['address'])
  end

  def check_log_in
    unless current_user
      render json: {
        error: true,
        error_code: 401,
        msg: '钱包地址错误'
      }
    end
  end

  def love?(cheer_word, address, code, love_power, hard)
    unix_time = Time.now.beginning_of_minute.to_i
    raw_data = "#{cheer_word}#{address}#{love_power}#{unix_time}#{code}"
    hash = Digest::SHA512.hexdigest(raw_data).to_i(16).to_s(2)
    hash.match(/0{#{hard}}$/)
  end
end
