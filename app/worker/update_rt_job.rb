class UpdateRtJob
  include Sidekiq::Worker
  def perform(id)
    tweets = Tweet.where(user_id:id)
    follwer_ids= tweets.first.user.followers.map(&:id)
    if follwer_ids.present? and tweets.present?
      tweets.each do |tweet|
        follwer_ids.each do |id|
          tx =TweetRelationship.where(tweet_id:tweet.id,follower_id:id, user_id:tweet.user_id)
          if tx.blank?
            TweetRelationship.create(tweet:tweet.tweet, user_id:tweet.user_id, follower_id:id, created_at:tweet.created_at, updated_at:tweet.updated_at, tweet_id:tweet.id)
          end
        end
      end  
    end    
  end
end