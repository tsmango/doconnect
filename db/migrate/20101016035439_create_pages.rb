class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :community_id
      t.integer :user_id
      t.integer :position
      t.string  :name
      t.string  :slug
      t.boolean :user_created, :default => true, :null => false
      t.timestamps
    end
    
    add_foreign_key :pages, :communities
    add_foreign_key :pages, :users
  end

  def self.down
    drop_table :pages
  end
end
