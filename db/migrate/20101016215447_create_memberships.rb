class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.integer :community_id
      t.integer :user_id
      t.integer :access, :null => false
      t.boolean :approved, :default => false, :null => false
      t.timestamps
    end
    
    add_foreign_key :memberships, :communities
    add_foreign_key :memberships, :users
  end

  def self.down
    drop_table :memberships
  end
end
