class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout 'two_columns'

  def index
    @users_stocks = current_user.users_stocks.order(:created_at)
    if @users_stocks.present?
      @total_investment = @users_stocks.pluck(:investment).inject(:+)
      @total_shares = @users_stocks.pluck(:quantity).inject(:+)
      @avg_lbp = @users_stocks.pluck(:last_buying_price).inject(:+)
      @avg_abp = @users_stocks.pluck(:average_buying_price).inject(:+)
    end
  end

  def get_current_price
    if params['users_stock_id'].blank? && params['bse_code'].blank?
      render(json: { message: 'Parameters missing' }) && return
    end

    users_stock = UsersStock.find(params['users_stock_id'])
    current_price = StockQuote::Stock.quote("BOM:#{params['bse_code']}").l

    current_price_in_decimal = BigDecimal(current_price)
    change_percentage = (current_price_in_decimal / users_stock.last_buying_price) - 1
    value = users_stock.investment * current_price_in_decimal

    render json: {
      current_price: current_price,
      users_stock_change_percentage: change_percentage,
      users_stock_value: value
    }
  end
end
