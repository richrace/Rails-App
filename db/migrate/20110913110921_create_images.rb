class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
    	    t.integer :user_id
    	    t.string :photo_file_name #Original file name
    	    t.string :photo_content_type #Mime type
    	    t.integer :photo_file_size #File size in bytes
    end
  end

  def self.down
    drop_table :images
  end
end
