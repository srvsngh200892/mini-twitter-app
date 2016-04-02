class TweetRelationship < ActiveRecord::Base

	validates :follower_id, presence: true
  validates :user_id, presence: true

  after_save :after_save_tasks
  after_create :after_save_tasks

  belongs_to :user

   def self.get_home_tweets(current_user)
   	Rails.cache.fetch("all-follower-tweets") do
    	TweetRelationship.includes(:user).where(follower_id:current_user.id).order("created_at desc").to_a
    end	
  end


  protected

  def after_save_tasks
  	cache_keys = ["all-follower-tweets"]
  	TweetRelationship.cache_buster(cache_keys)
  end 

  def self.cache_buster(cache_keys)
      cache_keys.each do |cache_key|
      	next if cache_key.to_s.blank?
        Rails.cache.delete(cache_key.to_s)
      end
      Rails.logger.info "="*80
      Rails.logger.info Time.now.to_s(:db)
      Rails.logger.info cache_keys.inspect
  end	
end	