Josched::Application.routes.draw do
  root to: 'welcome#index'

  resources :users do
    resources :appointments
    resources :tasks
  end

  get 'day/find', to: 'day#find'
  resources :day, only: :show
end
