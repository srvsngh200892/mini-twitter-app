class RelationshipsController < ApplicationController

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    UpdateRtJob.perform_async(current_user.id)
    respond_to do |format|
      format.html { redirect_to @user }
      format.json { render json: @user , status: :created }
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.json { render json: @user , status: :created }
    end
  end
end