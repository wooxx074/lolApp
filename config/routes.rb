Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#home'
  resources :leagues
  resources :teams
  resources :players
  resources :matches
  get '/matches/additional_match_info' => 'matches#additional_match_info', as: "current_match"
end
