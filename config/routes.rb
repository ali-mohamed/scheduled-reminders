Rails.application.routes.draw do
  resources :reminders, only: [:new, :create, :destroy, :show, :index]
  devise_for :users
  root to: "reminders#index"
end
