Josched::Application.routes.draw do
  root to: 'welcome#index'

  resources :users do
    resources :appointments
  end

  get 'day/:date' => 'events#index', as: 'day'
end
