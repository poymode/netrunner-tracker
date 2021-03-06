NetrunnerTracker::Application.routes.draw do
  resources :tournaments

  resources :matches

  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"

  # TODO: Why do I have to specify this?
  post "sessions/new"

  controller :sessions do
    get    'login'  => :new
    post   'login'  => :create
    delete 'logout' => :destroy
    get    'logout' => :destroy
  end

  get "registration/new"
  post "registration/new"

  controller :registration do
    get  'register' => :new
    post 'register' => :create
  end

  resources :cards

  resources :games do
    collection do
      get 'stats'
    end
  end

  resources :users

  resources :leagues

  resources :corporations

  resources :runners

  resources :users do
    resources :games do
      get 'anarch', :on => :collection
      get 'criminal', :on => :collection
      get 'shaper', :on => :collection
      get 'jinteki', :on => :collection
      get 'nbn', :on => :collection
      get 'weyland', :on => :collection
      get 'hb', :on => :collection
    end
    get 'stats', :on => :member
  end

  resources :leagues do
    resources :games
    resources :users
  end

  resources :tournaments do
    resources :users
  end

  resources :tournaments do
    resources :matches do
      resources :games do
        resources :users
      end
    end
  end

  resources :matches do
    resources :games
    resources :users
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'games#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
