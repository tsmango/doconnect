class CreatePageRevisions < ActiveRecord::Migration
  def self.up
    create_table :page_revisions do |t|
      t.integer :page_id
      t.integer :user_id
      t.text    :body, :default => '', :null => false
      t.text    :body_as_html, :default => '', :null => false
      t.timestamps
    end
    
    add_foreign_key :page_revisions, :pages
    add_foreign_key :page_revisions, :users
  end

  def self.down
    drop_table :page_revisions
  end
end
