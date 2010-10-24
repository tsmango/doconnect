class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.integer :community_id
      t.integer :user_id
      t.integer :position
      t.string  :path
      t.string  :url
      t.string  :slug
      t.text    :description
      t.string  :supported_formats
      t.string  :supported_methods
      t.boolean :requires_authentication, :default => false, :null => false
      t.boolean :rate_limited, :default => false, :null => false
      t.timestamps
    end
    
    add_foreign_key :resources, :communities
    add_foreign_key :resources, :users
  end

  def self.down
    drop_table :resources
  end
end
