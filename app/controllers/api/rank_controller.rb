class Api::RankController < ApplicationController
  before_action :user_rank_list, only: [:index]

  def index
    json = Rails.cache.fetch('user_rank', expires_in: 10.minutes) do
      data = @list.map do |item|
        user = User.find(item[:id])
        stock = Stock.find(item[:true_love_stock])
        {
          capital: item[:capital],
          user: user.nick_name,
          stock: stock.name
        }
      end
      {
        data: data,
        count: @list.count
      }
    end
    render json: json
  end

  private

  def user_rank_list
    @list = Rails.cache.read('user_rank_list')
    unless @list
      render json: { error: true, error_code: 404, msg: '暂无排行' }
    end
  end
end
