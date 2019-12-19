Rails.application.routes.draw do

  resources :pictures
  resources :comments
   root 'static_pages#home'
   get  '/help',    to: 'static_pages#help'
   get  '/about',   to: 'static_pages#about'
   get  '/contact', to: 'static_pages#contact'
   get  '/signup',  to: 'users#new'
   post '/signup',  to: 'users#create'
   get    '/login',   to: 'sessions#new'
   post   '/login',   to: 'sessions#create'
   delete '/logout',  to: 'sessions#destroy'
   resources :users
   resources :account_activations, only: [:edit]
   resources :password_resets, only: [:new, :create, :edit, :update]
   resources :microposts, only: [:create, :edit, :update, :destroy]
   get  '/index',   to: 'microposts#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
