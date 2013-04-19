class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :surname, :null=>false
      t.string :firstname, :null=>false
      t.string :phone
      t.integer :grad_year, :null=>false
      t.boolean :jobs, :default=>false
      t.string :email, :null=>false

      t.timestamps
    end

    add_index :users, :surname
    add_index :users, :email
  end

  def self.down
    remove_index :users, :surname
    remove_index :users, :email
    
    drop_table :users
  end
end
