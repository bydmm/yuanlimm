class Api::WishsController < ApplicationController
  before_action :check_geetest, only: [:create]
  before_action :check_log_in, only: [:create]
  before_action :check_limit, only: [:create]

  def index
    stock = Stock.find(params[:code])
    scope = StockTransaction.where(stock: stock, pay_type: 'love').order(id: :desc)
    data = scope.limit(5).map do |transaction|
      {
        id: transaction.id,
        user: transaction.payee.to_json,
        amount: transaction.amount,
        detail: transaction.detail,
        created_at: transaction.created_at.rfc2822
      }
    end
    render json: {
      count: scope.count,
      data: data
    }
  end

  def create
    hard = ENV['HARD'].to_i
    raito = ENV['WEB_WISH_RAITO'].to_i
    unless love?(params[:code], params[:cheer_word], params[:love_power], hard )
      render json: { success: false, msg: '应援失败，再接再厉！', hard: hard }
      return
    end
    stock = Stock.find(params[:code])
    detail = { cheer_word: params[:cheer_word], love_power: params[:love_power] }
    transaction = current_user.love(stock, detail, hard * raito, false)
    if transaction.save
      $redis.incr("user:#{current_user.id}:wishs:count")
      type =
        case transaction.type
        when 'CoinTransaction'
          'coin'
        when 'StockTransaction'
          'stock'
        end
      render json: {
        success: true,
        hard: hard,
        type: type,
        amount: transaction.amount
      }
    else
      render json: { success: false, msg: transaction.errors.full_messages.join(', ') }
    end
  end

  private

  def check_limit
    count = Transaction.user_count(current_user)
    limit = ENV['WEB_WISH_LIMIT'].to_i
    if count > limit
      msg = "每日网页许愿上限#{limit}次，超过限制请使用官方许愿软件。"
      render json: { success: false, msg: msg, hard: ENV['HARD'].to_i }
    end
  end

  def love?(code, cheer_word, love_power, hard)
    unix_time = Time.now.beginning_of_minute.to_i
    raw_data = "#{cheer_word}#{love_power}#{unix_time}#{code}"
    hash = Digest::SHA512.hexdigest(raw_data).to_i(16).to_s(2)
    hash.match(/0{#{hard}}$/)
  end
end
