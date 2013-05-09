Josched::Application.routes.draw do
  root to: 'welcome#index'

  resources :users do
    resources :appointments, except: :index
    resources :tasks, except: :index
  end

  resources :day, only: :show
end
