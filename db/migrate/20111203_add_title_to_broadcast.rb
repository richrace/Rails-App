class AddTitleToBroadcast < ActiveRecord::Migration
  def self.up
    add_column :broadcasts, :title, :string
  end
 
  def self.down
    remove_column :broadcasts, :title
  end
end