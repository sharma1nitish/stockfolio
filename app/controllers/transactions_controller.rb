class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_users_stocks = current_user.users_stocks
    current_users_stock = current_users_stocks.where(stock_id: transaction_params[:stock_id]).first_or_initialize
    current_users_stock.transaction_type = transaction_params[:transaction_type]

    if current_users_stock.inactive? && current_users_stock.transaction_type = 'buy'
      status = :created
    else
      status = :updated
    end

    if !current_users_stock.persisted?
      current_users_stock.quantity = transaction_params[:quantity]
      current_users_stock.last_buying_price = transaction_params[:price_per_unit]
      transaction = current_users_stock.transactions.build(transaction_params.except(:stock_id))
      current_users_stock.save

      respond_with_errors_for(transaction) && return if transaction.errors.present?
      respond_with_errors_for(current_users_stock) && return if current_users_stock.errors.present?

      status = :created
    else
      transaction = current_users_stock.transactions.create(transaction_params.except(:stock_id))
    end

    respond_with_errors_for(transaction) && return if transaction.errors.present?

    current_users_stocks = current_users_stocks.active

    total_investment = current_users_stocks.pluck(:investment).inject(:+) || 0
    total_quantity = current_users_stocks.pluck(:quantity).inject(:+) || 0
    total_abp = current_users_stocks.pluck(:average_buying_price).inject(:+)
    total_lbp = current_users_stocks.pluck(:last_buying_price).inject(:+)
    avg_abp = total_abp.present? ? total_abp / current_users_stocks.count : 0
    avg_lbp = total_lbp.present? ? total_lbp / current_users_stocks.count : 0
    investment_percentage = (current_users_stock.investment / total_investment) * 100

    render json: {
      user_stock_id: current_users_stock.id,
      name: current_users_stock.stock.symbol,
      investment: current_users_stock.investment.floor,
      investment_percentage: investment_percentage.truncate(1).to_f,
      quantity: current_users_stock.quantity,
      last_buying_price: current_users_stock.last_buying_price.truncate(1).to_f,
      average_buying_price: current_users_stock.average_buying_price.truncate(1).to_f,
      bse_code: current_users_stock.stock.bse_code,
      company_count: current_users_stocks.count,
      total_investment: total_investment.floor,
      total_quantity: total_quantity,
      avg_lbp: avg_lbp.truncate(1).to_f,
      avg_abp: avg_abp.truncate(1).to_f,
      status: status
    }
  end

  private

  def transaction_params
    params.require(:transaction).permit(:stock_id, :quantity, :price_per_unit, :transacted_at, :transaction_type, :brokerage, :is_brokerage_percentage, :is_brokerage_amount)
  end

  def respond_with_errors_for(record)
    render json: { errors: record.errors.messages.values.flatten.join(', ') }, status: 422
  end
end
