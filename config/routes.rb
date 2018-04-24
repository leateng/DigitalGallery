Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'

  get 'sessions/new'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup'  => 'users#new'
  get 'login' => "sessions#new"
  post 'login' => "sessions#create"
  delete "logout" => "sessions#destroy"


  resources :users, constraints: { id: /\d+/ } do
    member do
      get :reset_password, action: "edit_password"
      post :reset_password, action: "update_password"
      post :app, action: "upload_app"
    end

    resources :attachments, constraints: { id: /\d+/ } do
      member do
        post "relate_video/:video_id", action: "relate_video", as: "relate_video_attachment"
      end
    end
  end
  resources :clients, constraints: { id: /\d+/ }

  namespace :api do
    namespace :v1 do
      resources :sessions, only: [:create]
      resources :users, only: [:index, :create, :show, :update, :destroy] do
        member do
          get :images
        end
      end
      # 原文有 microposts, 我们现在把它注释掉
      # resources :microposts, only: [:index, :create, :show, :update, :destroy]
    end
  end
end
