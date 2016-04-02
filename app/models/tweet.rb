class Tweet < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
 
  belongs_to :user
  has_many :tweet_relationships

  scope :acitve, -> { where(status: true) }
  enum role: [:User]
  enum status: [:Inactive, :Active]

  after_save :after_save_tasks
  after_create :after_save_tasks

  validates_length_of :tweet, :maximum => 142

  include Tire::Model::Search
  include Tire::Model::Callbacks

  mapping do
    indexes :tweet
  end

  def self.search(query) #elastic search 
    query = query.gsub(/[^0-9A-Za-z.]/, ' ')
    @searchResults = tire.search(load: true) do
      size 1000
      query do
        boolean do
          must { string ('*'+query+'*'), default_operator: "AND" } if query.present?
        end

      end
    end
    @searchResults.results
  end

  def self.get_all_active_tweets(current_user)
    Tweet.includes(:user).where(user_id:([current_user.id]+current_user.following.map(&:id)),status:true).order("created_at desc")
  end

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