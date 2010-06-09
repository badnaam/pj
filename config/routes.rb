ActionController::Routing::Routes.draw do |map|
#    map.resources :searches, :collection => {:search_set => :put, :search_show => :get}, :path_names => {:show => "search_show"}
    map.resources :searches, :collection => {:search_set =>  :get}

    map.resources :merchantmemberships
    map.resources :ets

    map.resources :gcertificates, :has_many => [:gcertsteps, :gcertifications], :belongs_to => :merchant
    #    map.resources :gcertifications
    map.resources :gcertsteps

    map.resources :loyalty_benefits

    map.resources :images

    map.resources :password_resets
    map.register "register/:activation_code", :controller => "activations", :action => "new"
    map.activate "activate/:id", :controller => "activations", :action => "create"
    
    #    map.connect "events/:action", :controller => 'events', :action => /[a-z_]+/i
    map.resources :events, :has_many => [:comments, :categories], :has_one => :address
    map.resources :merchants, :has_many => [:images, :loyalty_benefits, :gcertificates, :merchant_memberships], :has_one => [:address], :belongs_to => [:merchant_category, :owner]
    map.resources :merchant_graphs,   :collection => {:graph => :get, :g_category_points => :get, :g_historical_points => :get}
    map.resources :images
    
    map.login "login", :controller =>:user_sessions, :action => "new"
    map.logout "logout", :controller =>:user_sessions, :action => "destroy"
    map.gaccount "gaccount", :controller => :gaccount, :action => "index"
    map.resources :user_sessions
    
    map.resources :roles, :has_many => [:users]
    map.resources :categories, :has_many => [:events, :categorizations]
    map.resources :merchant_categories, :has_many => [:merchants]
    map.resources :gcertsteps, :has_many => [:merchants, :gcertifications, :merchant_categories], :collection => {:getsubcat => :get}
    #    map.resources :users, :has_many => [:roles, :friendships, :friends, :events, :articles, :comments, :assignments, :images, :interests, :owned_merchants, :merchant_memberships],
    #      :member => {:deactivate => :put, :activate => :put}, :has_one => :address
    map.resources :users, :member => {:deactivate => :put, :activate => :put} do |users|
        users.resources :roles
        users.resources :events
        users.resources :articles
        users.resources :comments
        users.resources :images
        users.resources :owned_merchants, :controller => :merchants
        users.resources :merchant_memberships
        users.resource :address
    end
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

    map.with_options :controller => 'pages' do |page|
        page.user_details '/user_details', :action => 'user_details'
        page.about '/about', :action => 'about'
        page.merchant_details '/merchant_details', :action => 'merchant_details'
        page.faq '/faq', :action => 'faq'
        page.terms '/terms', :action => 'terms'
        page.pvp '/pvp', :action => 'pvp'
        page.feedback '/feedback', :action => 'feedback'
    end
    
    map.root :controller =>"home"
    map.connect ':controller/:action/:id'
    map.connect ':controller/:action/:id.:format'
end
