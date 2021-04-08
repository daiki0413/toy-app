class RelationshipsController < ApplicationController
    before_action:authenticate_user
  
    def create
      @follow=Relationship.create(follower_id:@current_user.id,followed_id:params["followed_id"])
      @follow.save
      redirect_to "/users/#{params[:followed_id]}"
    end
    
    def destroy
      @follow=Relationship.find_by(follower_id:@current_user.id,followed_id:params["followed_id"])
      @follow.destroy
      redirect_to "/users/#{params[:followed_id]}"
    end
end
