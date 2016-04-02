class HomeController < ApplicationController
	layout :get_panel_layout

	def home
		@all_tweets = TweetRelationship.get_home_tweets(current_user).page(params[:page]).per(15)
		@follwer_count = current_user.followers.count
		@following_count = current_user.following.count
	end

	def index
	end

	def show
	end

	def tweet
		@tweet = Tweet.new(tweet_params)
		@tweet.user_id = current_user.id
    respond_to do |format|
      if @tweet.save
        CreateTweets.perform_async(current_user.id)
        format.html { redirect_to admin_kitchens_path, notice: 'order was successfully created.' }
        format.json { render json: @tweet, status: :created }
      else
      	format.json { render json: @tweet.errors, status: :unprocessable_entity }
        format.html { render action: 'new' }
      end
    end
	end

	def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private	

	protected

	def get_panel_layout 
    "twitter" 
  end

  def tweet_params
    params.require(:tweet).permit(:tweet)
  end	
end	