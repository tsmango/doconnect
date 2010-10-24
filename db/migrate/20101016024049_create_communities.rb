class CreateCommunities < ActiveRecord::Migration
  def self.up
    create_table :communities do |t|
      t.integer :user_id
      t.string  :name
      t.string  :subdomain
      t.integer :privacy, :null => false
      t.string  :description
      t.timestamps
    end
    
    add_foreign_key :communities, :users
  end

  def self.down
    drop_table :communities
  end
end
