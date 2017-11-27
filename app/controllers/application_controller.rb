class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected

  [:sign_up, :sign_in].each do |action|
    define_method("after_#{action}_path_for") { |resource| dashboard_path }
  end
end
