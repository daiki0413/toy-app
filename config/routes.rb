Rails.application.routes.draw do
    get "/",to:"home#top"
    get "/about",to:"home#about"
    
    get "/posts",to:"posts#index"
    get "/posts/new",to:"posts#new"
    post "/posts/create",to:"posts#create"
    get "posts/:id",to:"posts#show"
    get "/posts/:id/edit",to:"posts#edit"
    post "/posts/:id/update",to:"posts#update"
    post "/posts/:id/destroy",to:"posts#destroy"
    
    get "/users",to:"users#index"
    get "/signup",to:"users#signup"
    post "/users/create",to:"users#create"
    get "/users/:id",to:"users#show"
    get "/users/:id/edit",to:"users#edit"
    post "/users/:id/update",to:"users#update"
    post "/users/:id/destroy",to:"users#destroy"
    get "/login",to:"users#login_form"
    post "/login",to:"users#login"
    post "/logout",to:"users#logout"
    get "/users/:id/likes",to:"users#likes"
    get "/users/:id/following",to:"users#following"
    get "/users/:id/followers",to:"users#followers"
    
    post "/likes/:post_id/create",to:"likes#create"
    post "/likes/:post_id/destroy",to:"likes#destroy"
    
    post '/relationships/:followed_id/create',to:'relationships#create'
    post 'relationships/:followed_id/destroy',to:'relationships#destroy'
end
