class CreateTweetRelationship < ActiveRecord::Migration
  def change
    create_table :tweet_relationships do |t|
    	t.integer :follower_id
      t.text :tweet
      t.integer :user_id
      t.integer :tweet_id

      t.timestamps null: false
    end
    add_index :tweet_relationships, :follower_id
    add_index :tweet_relationships, :user_id
  end
end
