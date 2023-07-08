Rails.application.routes.draw do
	root 'posts#index'
	get 'rooms', to: 'rooms#index'
	get '/posts', to: 'posts#index'
	post '/posts/location', to: 'posts#index'
	post '/update', to: 'posts#update'
	post 'delete_application/:id', to: 'posts#delete_application'
	get '/posts/edit/:id', to: 'posts#edit'
	get '/posts/show/:id', to: 'posts#show'
	get 'sign-up', to: 'users#new', as: 'signup'
	get '/login', to: 'users#login'
	get '/posts/nearby', to: 'posts#nearby'
	get 'users/logout', to: 'users#logout'
	get 'posts/create_post'
	get 'users/index', to: 'users#index'
	get 'posts/new', to: 'posts#new'
	post 'users/create', to: 'users#create'
	post '/message', to: 'messages#create'
	post 'users/validate_login', to: 'users#validate_login'
	get 'posts/applicants', to: 'posts#applicants'
	get 'posts/applied', to: 'posts#applied'
	post '/create_post', to: 'posts#create_post'
	get '/users/:id', to: 'rooms#show'
	get '/profile', to: 'users#show_profile'
	get '/edit_profile', to: 'users#edit_profile'
	get '/change_password', to: 'users#change_password'
	post '/users/update', to: 'users#update'
	post '/update_password', to: 'users#update_password'
	resources :posts
	post '/posts/:id/apply', to: 'posts#apply', as: 'apply_to_post'
	post 'assign_applicant/:post_id/:user_id', to: 'posts#assign_applicant', as: 'assign_applicant'
	post 'cancel_assignee/:post_id', to: 'posts#cancel_assignee', as: 'cancel_assignee'
	resources :rooms

	# Defines the root path route ("/")
	# root "articles#index"
end
