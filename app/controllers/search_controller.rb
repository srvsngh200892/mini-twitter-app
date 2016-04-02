class SearchController < ApplicationController
  layout :get_panel_layout

  def index
    query = query_check(params[:query]) rescue nil
    users = User.search(query) if query.present?
    searchResult= {}
    searchResult["users"] = {}
    searchResult["tweets"] = {}
    users = User.where(id: (users - [current_user])).limit(max_results)
    users.each do |user|
      searchResult["users"][user.id] = user_search_hash(user)
    end
    if query.present?
      tweets = Tweet.search(query)
      tweets = tweets.first(max_results)
      searchResult["tweets"] = tweets.map { |o| tweet_search_hash(o) }
    end
    @results = searchResult.to_json
  end

  def query_check(query)
    if query.present?
      query = query.gsub(/[=&|><!(){}\[\]^"~*?:\/\\]/i, '')
      query = query.strip
    else
      query = ''
    end
    query
  end

  private

  def max_results
    200
  end

  def user_search_hash user
    {
        user_info: user.attributes.slice("id", "first_name", "last_name"),
        followers: current_user.following.map(&:id)

    }
  end

  def tweet_search_hash tweet
    tweet.attributes.slice("id", "user_id", "tweet")
  end

  def get_panel_layout 
    "twitter" 
  end

end