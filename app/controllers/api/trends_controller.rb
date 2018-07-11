class Api::TrendsController < ApplicationController
  def index
    stock = Stock.find(params[:code])
    trend_type = params[:trend_type] || 'day_close'
    limit = params[:limit] || 6
    scope = StockTrend.where(stock: stock, trend_type: trend_type).order(datetime: :desc)
    data = scope.limit(limit).map do |trend|
      {
        price: trend.price,
        datetime: trend.datetime.rfc2822
      }
    end
    data.reverse!
    data.push(price: stock.price, datetime: Time.now.rfc2822)
    render json: {
      data: data
    }
  end
end
