class PostsController < ApplicationController
    before_action:authenticate_user
    before_action:ensure_correct_user,{only:["edit","update","destroy"]}
    
    def ensure_correct_user
        @post=Post.find(params["id"])
        if @current_user.id!=@post.user_id
            flash["notice"]="権限がありません"
            redirect_to "/posts"
        end  
    end
    def index
        @posts=Post.where(user_id:[*@current_user.following_ids,@current_user.id]).order(created_at: :desc).paginate(page:params[:page])
    end
    def new
        @post=Post.create
    end
    def create
        @post=Post.create(content:params["content"],user_id:@current_user.id)
        if @post.save
         flash[:notice] = "投稿が完了しました"
         redirect_to "/posts"
        else
         render("posts/new")
        end
    end
    def show
        @post=Post.find(params["id"])
        @user=@post.user
        @likes_count=Like.where(post_id:@post.id).count
    end
    def edit
        @post=Post.find(params["id"])
    end
    def update
        @post=Post.find(params["id"])
        @post.content=params["content"]
        
        if @post.save
         flash[:notice] = "編集が完了しました"
         redirect_to "/posts"
        else
         render("posts/edit")
        end      
    end 
    def destroy
        @post=Post.find(params["id"])
        @post.destroy
        flash[:notice] = "削除が完了しました"
        redirect_to "/posts"
    end

end
