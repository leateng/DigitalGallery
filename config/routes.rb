Rails.application.routes.draw do
  get 'attachments/index'

  get 'attachments/new'

  get 'attachments/create'

  get 'attachments/edit'

  get 'attachments/update'

  get 'attachments/destroy'

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


  resources :users do
    resources :attachments

    member do
      get :gallery
    end
  end

  resources :clients

  #get 'clients', to: "users#clients_index", as: :clients_index
  #get 'clients/:id', to: "users#clients_show", as: :clients_show, constraints: {id: /\d+/}
  #get 'clients/new', to: "users#clients_new", as: :new_client
  #post 'clients', to: "users#clients_create", as: :create_client

end
