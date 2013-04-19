class AddLevelToUserDetails < ActiveRecord::Migration
  def self.up
    add_column :user_details, :level, :integer
  end
 
  def self.down
    remove_column :user_details, :level
  end
end