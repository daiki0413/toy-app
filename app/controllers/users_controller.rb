class UsersController < ApplicationController
    before_action:authenticate_user,{only:["index","show","edit","update","destroy","followers","following"]}
    before_action:forbit_login_user,{only:["signup","create","login","login_form"]}
    before_action:ensure_current_user,{only:["edit","update"]}
    before_action:admin_user,{only:["destroy"]}

    def ensure_current_user
        if @current_user.id!=params["id"].to_i
            flash["notice"]="権限がありません"
            redirect_to "/posts"
        end
    end
    def admin_user
        unless @current_user.admin?
               flash["notice"]="権限がありません"
               redirect_to "/users"
        end    
    end    
    def index
        @users=User.all.order(created_at: :asc).paginate(page:params[:page])
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
        @posts_count=@user.posts.count
        @likes=Like.where(user_id:@user.id)
        @likes_count=@likes.count
    end
    def edit
        @user=User.find(params["id"])
    end
    def update
        @user=User.find(params["id"])
        @user.name=params["user"]["name"]
        @user.mail=params["user"]["mail"]

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
    def destroy
        @user=User.find(params["id"])
        @user.destroy
        flash[:notice] = "削除が完了しました"
        redirect_to "/users"              
    end
    def login_form
    end
    def login
        @user=User.find_by(mail:params["user"]["mail"])
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
        @likes=Like.where(user_id:@user.id).paginate(page:params[:page])
        @posts_count=@user.posts.count
        @likes_count=@likes.count
    end
    def followers
        @user=User.find(params["id"])
        @users=@user.followers.paginate(page:params[:page])
        @posts_count=@user.posts.count
        @likes=Like.where(user_id:@user.id)
        @likes_count=@likes.count        
    end    
    def following
        @user=User.find(params["id"])
        @users=@user.following.paginate(page:params[:page])
        @posts_count=@user.posts.count
        @likes=Like.where(user_id:@user.id)
        @likes_count=@likes.count        
    end

end