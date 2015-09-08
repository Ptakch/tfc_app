Rails.application.routes.draw do
  
  resources :players, :teams
  root 'players#index'
end
