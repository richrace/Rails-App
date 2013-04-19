class AddFeedTypeToBroadcast < ActiveRecord::Migration
  def self.up
    add_column :broadcasts, :feed_type, :string
  end
 
  def self.down
    remove_column :broadcasts, :feed_type
  end
end