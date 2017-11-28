class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout 'two_columns'

  def index
    @users_stocks = current_user.users_stocks.active.order(:created_at)

    @total_investment = @users_stocks.pluck(:investment).inject(:+) || 0
    @total_shares = @users_stocks.pluck(:quantity).inject(:+) || 0
    @avg_lbp = @users_stocks.pluck(:last_buying_price).inject(:+) || 0
    @avg_abp = @users_stocks.pluck(:average_buying_price).inject(:+) || 0
  end

  def get_stocks
    render json: { stocks: Stock.where('symbol ILIKE :symbol', symbol: "%#{params['term']['term']}%"), status: :ok }
  end

  def get_current_price
    if params['users_stock_id'].blank? && params['bse_code'].blank?
      render(json: { message: 'Parameters missing' }) && return
    end

    users_stock = UsersStock.active.find(params['users_stock_id'])
    current_price = StockQuote::Stock.quote("BOM:#{params['bse_code']}").l

    current_price_in_decimal = BigDecimal(current_price)
    change_percentage = ((current_price_in_decimal / users_stock.last_buying_price) - 1) * 100
    value = users_stock.quantity * current_price_in_decimal

    render json: {
      current_price: BigDecimal(current_price).truncate(1).to_f,
      users_stock_change_percentage: change_percentage.truncate(1).to_f,
      users_stock_value: value.truncate(1).to_f
    }
  end
end
