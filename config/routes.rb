ActionController::Routing::Routes.draw do |map|
  map.resources :gcertsteps

    map.resources :loyalty_benefits

    map.resources :images

    map.resources :password_resets
    map.register "register/:activation_code", :controller => "activations", :action => "new"
    map.activate "activate/:id", :controller => "activations", :action => "create"
    
    #    map.connect "events/:action", :controller => 'events', :action => /[a-z_]+/i
    map.resources :events, :has_many => [:comments, :categories, :assignments], :has_one => :address
    map.resources :merchants, :has_many => [:images, :loyalty_benefits, :merchant_categories, :gcertsteps], :has_one => :address
    map.resources :images
    
    map.login "login", :controller =>:user_sessions, :action => "new"
    map.logout "logout", :controller =>:user_sessions, :action => "destroy"
    map.resources :user_sessions
    
    map.resources :roles, :has_many => [:users, :assignments]
    map.resources :categories, :has_many => [:events, :categorizations]
    map.resources :merchant_categories, :has_many => [:merchants, :merchant_categorizations]
    map.resources :gcertsteps, :has_many => [:merchants, :gcertifications]
    map.resources :users, :has_many => [:roles, :friendships, :friends, :events, :articles, :comments, :assignments, :images, :interests, :merchants],
      :member => {:deactivate => :put, :activate => :put}, :has_one => :address
    map.resources :comments
    map.resources :articles, :has_many => :comments
    map.resources :friendships
    map.resources :assisgnments, :belongs_to =>[:users, :roles]


    #  map.resources :friendships
  
    # The priority is based upon order of creation: first created -> highest priority.

    # Sample of regular route:
    #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
    # Keep in mind you can assign values other than :controller and :action

    # Sample of named route:
    #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
    # This route can be invoked with purchase_url(:id => product.id)

    # Sample resource route (maps HTTP verbs to controller actions automatically):
    #   map.resources :products

    # Sample resource route with options:
    #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

    # Sample resource route with sub-resources:
    #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
    # Sample resource route with more complex sub-resources
    #   map.resources :products do |products|
    #     products.resources :comments
    #     products.resources :sales, :collection => { :recent => :get }
    #   end

    # Sample resource route within a namespace:
    #   map.namespace :admin do |admin|
    #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
    #     admin.resources :products
    #   end

    # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
    # map.root :controller => "welcome"

    # See how all your routes lay out with "rake routes"

    # Install the default routes as the lowest priority.
    # Note: These default routes make all actions in every controller accessible via GET requests. You should
    # consider removing or commenting them out if you're using named routes and resources.

    map.root :controller =>"home"
    map.connect ':controller/:action/:id'
    map.connect ':controller/:action/:id.:format'
end
