class CreateDiscussions < ActiveRecord::Migration
  def self.up
    create_table :discussions do |t|
      t.integer   :community_id
      t.integer   :user_id
      t.boolean   :sticky, :default => false, :null => false
      t.string    :title
      t.string    :slug
      t.integer   :replies_count, :default => 0, :null => false
      t.timestamp :last_reply_at
      t.timestamps
    end
    
    add_foreign_key :discussions, :communities
    add_foreign_key :discussions, :users
  end

  def self.down
    drop_table :discussions
  end
end
