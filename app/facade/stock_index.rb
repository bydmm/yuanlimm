class StockIndex
  attr_reader :sort, :keyword, :user, :page

  def initialize(other_sort, other_keyword, other_user, other_page)
    @sort = other_sort
    @keyword = other_keyword
    @user = other_user
    @page = other_page || 1
  end

  def selected_codes
    @selected_codes ||= SelectedStock.select('stock_code').where(user: user).map(&:stock_code)
  end

  def scope
    @scope = Stock
    if keyword.present?
      client = OpenSearchSearch.new(keyword)
      @scope = @scope.where(code: client.search)
    end
    @scope =
      case sort
      when 'marketValue'
        @scope.order(market_value: :desc)
      when 'buyPrice'
        @scope.order(buy_price: :desc)
      when 'salePrice'
        @scope.where('sale_price > 0').order(:sale_price)
      when 'selected'
        @scope.where(code: selected_codes).order(market_value: :desc)
      else
        @scope.order(:order)
      end
    @scope = @scope.page(page).per(12)
    @scope
  end
end
