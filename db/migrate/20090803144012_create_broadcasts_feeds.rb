class CreateBroadcastsFeeds < ActiveRecord::Migration
  def self.up
    create_table "broadcasts_feeds", :id => false, :force => true do |t|
      t.integer :broadcast_id, :null => :no
      t.integer :feed_id, :null => :no
    end
  end

  def self.down
    drop_table "broadcasts_feeds"
  end
end
