class MyOrders
  attr_reader :code, :user, :page

  def initialize(other_code, other_status, other_page, other_user)
    @code = other_code
    @status = other_status
    @user = other_user
    @page = other_page || 1
  end

  def status
    @status || 'padding'
  end

  def stock
    @stock ||= Stock.find(code)
  end

  def scope
    @scope = StockOrder.where(user: user)
    @scope = @scope.where(stock: stock) if code.present?
    @scope = @scope.where(status: status) if status.present?
    @scope.order(id: :desc).page(page).per(20)
  end
end
