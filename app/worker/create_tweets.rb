class CreateTweets
  include Sidekiq::Worker
  def perform(id)
    tweet = Tweet.where(id:id).first
    follwer_ids= tweet.user.followers.map(&:id)
    if follwer_ids.present?
      follwer_ids.each do |id|
        TweetRelationship.create(tweet:tweet.tweet, user_id:tweet.user_id, follower_id:id, created_at:tweet.created_at, updated_at:tweet.updated_at, tweet_id:tweet.id)
      end
    end    
  end
end