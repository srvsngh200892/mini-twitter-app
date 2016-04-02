class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
    	t.text   :tweet
    	t.boolean :status, default: true
    	t.references :user
      t.timestamps null: false
    end
    add_index :tweets, :user_id
  end
end
