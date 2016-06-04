Rails.application.routes.draw do

  namespace :api do
   resources :users, :defaults => { :format => 'json' }
   # put "users/:email/delete" => "users#delete", :defaults => { :format => 'json' }
   resources :users do
     post :delete, on: :member, :defaults => { :format => 'json' }
   end
   resources :books, :defaults => { :format => 'json' }
   resources :books do
      post :is_sold, on: :member, :defaults => { :format => 'json' }
      post :update_views, on: :member, :defaults => { :format => 'json' }
   end
   resources :sessions, :defaults => { :format => 'json' }
   resources :sessions do
      post :delete, on: :member, :defaults => { :format => 'json' }
   end
   match 'sessions/update_session_token' => 'sessions#update_session_token', :via => :post, :defaults => { :format => 'json' }
   match 'users/send_mail' => 'users#send_mail', :via => :post, :defaults => { :format => 'json' }
   match 'users/update_password' => 'users#update_password', :via => :post, :defaults => { :format => 'json' }
   match 'users/update_service_token' => 'users#update_service_token', :via => :post, :defaults => { :format => 'json' }

   match 'books/search/get_unique_search_params' => 'books#get_unique_search_params', :via => :get

  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
