Rails.application.routes.draw do
  root 'dashboard#index'

  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }, skip: [:sessions, :registrations]

  as :user do
    get 'signup', to: 'users/registrations#new', as: :new_user_registration
    post 'signup', to: 'users/registrations#create', as: :user_registration
    put 'change_password', to: 'users/registrations#change_password'

    get 'login', to: 'users/sessions#new', as: :new_user_session
    post 'login', to: 'users/sessions#create', as: :user_session
    delete 'logout', to: 'users/sessions#destroy', as: :destroy_user_session
  end

  scope module: 'dashboard' do
    get 'dashboard', action: :index
  end

  post 'get_current_price', to: 'dashboard#get_current_price'
  get 'get_stocks', to: 'dashboard#get_stocks'

  resources :transactions, only: [:create]
end
