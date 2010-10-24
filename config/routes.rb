ActionController::Routing::Routes.draw do |map|
  map.resources :users, :except => [:edit, :update, :destroy]
  map.resources :user_sessions
  
  map.register  'register',   :controller => 'users', :action => 'new'
  map.login     'login',      :controller => 'user_sessions', :action => 'new'
  map.logout    'logout',     :controller => 'user_sessions', :action => 'destroy'
  
  map.home      'home',       :controller => 'dashboard', :action => 'marketing'
  map.dashboard 'dashboard',  :controller => 'dashboard'
  
  map.search    'search',     :controller => 'communities', :action => 'search'
  
  map.with_options :conditions => {:custom_domain => false} do |base|
    base.root :controller => 'dashboard'
    
    base.resources :communities, :except => [:index, :edit, :update, :destroy]
    
    base.connect 'communities/process_name', :controller => 'communities', :action => 'process_name'
  end
  
  map.with_options :conditions => {:custom_domain => true} do |community|
    community.root :controller => 'pages', :action => 'show', :id => 'overview'
    
    community.activity 'activity', :controller => 'communities', :action => 'activity'
    
    community.resources :memberships, :member => {:approve => :post, :disapprove => :delete, :promote => :post, :demote => :delete}, :except => [:edit]
    
    community.resources :pages, :member => {:history, :get}
    
    community.resources :discussions do |discussion|
      discussion.resources :replies, :only => [:create, :update, :destroy]
    end
    
    community.resources :resources
  end
  
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
