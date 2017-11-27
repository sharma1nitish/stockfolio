class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout 'two_columns'

  def index
  end
end
