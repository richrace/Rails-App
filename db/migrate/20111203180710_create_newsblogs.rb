class CreateNewsblogs < ActiveRecord::Migration
  def self.up
    create_table :newsblogs do |t|
      t.integer :broadcast_id
      t.timestamps
    end
  end

  def self.down
    drop_table :newsblogs
  end
end
