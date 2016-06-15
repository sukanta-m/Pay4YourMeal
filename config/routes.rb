Rails.application.routes.draw do

  root 'blogs#index'

  mount Ckeditor::Engine => '/ckeditor'
  #mount Resque::Server, :at => "/resque"
  mount API => "/api", :at => '/'

  devise_for :users, :controllers => {:passwords => 'passwords'}

  resources :blogs do
    collection do
      get 'shared_blogs'
      get 'unread_blogs'
      get 'received_blogs'
    end

    member do
      resources :shared_blogs, only: [:create]

      get 'shared_friends'
      put 'mark_private_public'
    end
  end

  resources :friendships, only: [:create, :update, :destroy] do
    collection do
      get 'get_requested_friends'
    end
  end
  resources :friends, only: [:index] do
    collection do
      get 'search_user'
    end
  end
end
