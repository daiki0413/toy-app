class UsersController < ApplicationController
    before_action:authenticate_user,{only:["index","show","edit","update"]}
    before_action:forbit_login_user,{only:["signup","create","login","login_form"]}
    before_action:ensure_current_user,{only:["edit","update"]}
    
    def ensure_current_user
        if @current_user.id!=params["id"].to_i
            flash["notice"]="権限がありません"
            redirect_to "/posts"
        end  
    end
    def index
        @users=User.all.order(created_at: :desc)
    end
    def signup
        @user=User.create
    end
    def create
        @user=User.create(name:params["user"]["name"],mail:params["user"]["mail"],password:params["user"]["password"],image:"default.jpg")
        if @user.save
        session["user_id"]=@user.id
        flash[:notice] = "登録が完了しました"
         redirect_to "/users"
        else
         render("users/signup")
        end            
    end
    def show
        @user=User.find(params["id"])
    end
    def edit
        @user=User.find(params["id"])
    end
    def update
        @user=User.find(params["id"])
        @user.name=params["user"]["name"]
        @user.mail=params["user"]["mail"]
        @user.password=params["user"]["password"]

        if params["image"]
         @user.image="#{@user.id}.jpg"
         image=params["image"]
         File.binwrite("public/user_images/#{@user.image}",image.read)
        end 
        
        if @user.save
         flash[:notice] = "編集が完了しました"
         redirect_to "/users"
        else
         render("users/edit")
        end  
    end
    def login_form
    end
    def login
        @user=User.find_by(name:params["user"]["mail"])
        if @user && @user.authenticate(params["user"]["password"])
         session["user_id"]=@user.id
         flash[:notice] = "ログインしました"
         redirect_to "/posts"
        else
         @error_message="メールまたはパスワードが間違っています"
         render("users/login_form")
        end
    end
    def logout
         session["user_id"]=nil
         flash[:notice] = "ログアウトしました"
         redirect_to "/login"        
    end
    def likes
        @user=User.find(params["id"])
        @likes=Like.where(user_id:@user.id)
    end
end
