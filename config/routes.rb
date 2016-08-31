Rails.application.routes.draw do

  root 'homes#index'

  devise_for :users, :controllers => {:passwords => 'passwords'}

  resources :marketings do
    put :approve
  end
  resources :groups do
    collection do
      resources :memberships do
        get :add_password
        put :update_member_details
      end
      get :any_group
      get :switch
      post :change_date
    end
    resources :meals, only: [:index]
    resources :members do
      resources :meals, only: [:create, :update]
    end
  end
  get "memberships/invitation", to: "memberships#accept"
end
