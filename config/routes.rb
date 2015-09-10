Rails.application.routes.draw do
	root 'teams#index'
	resources :players, :teams, :games
	delete 'games/delete' => 'games#destroy'
end
