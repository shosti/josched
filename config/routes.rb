Josched::Application.routes.draw do
  root to: 'welcome#index'

  resources :users do
    resources :appointments
    resources :tasks
  end

  resources :day, only: :show
end
