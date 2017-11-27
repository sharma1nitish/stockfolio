Rails.application.routes.draw do
  root 'pages#home'

  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }, skip: [:sessions, :registrations]

  as :user do
    get 'signup' => 'users/registrations#new', as: :new_user_registration
    post 'signup' => 'users/registrations#create', as: :user_registration
    put 'change_password' => 'users/registrations#change_password'

    get 'login' => 'users/sessions#new', as: :new_user_session
    post 'login' => 'users/sessions#create', as: :user_session
    delete 'logout' => 'users/sessions#destroy', as: :destroy_user_session
  end

  scope module: 'dashboard' do
    get 'dashboard', action: :index
  end
end
