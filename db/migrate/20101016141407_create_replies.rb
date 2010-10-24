class CreateReplies < ActiveRecord::Migration
  def self.up
    create_table :replies do |t|
      t.integer :discussion_id
      t.integer :user_id
      t.text    :body, :default => '', :null => false
      t.text    :body_as_html, :default => '', :null => false
      t.timestamps
    end
    
    add_foreign_key :replies, :discussions
    add_foreign_key :replies, :users
  end

  def self.down
    drop_table :replies
  end
end
