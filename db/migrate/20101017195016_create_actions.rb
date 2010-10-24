class CreateActions < ActiveRecord::Migration
  def self.up
    create_table :actions do |t|
      t.integer :community_id
      t.integer :action_type_id
      t.integer :user_id
      t.string  :actionable_type
      t.integer :actionable_id
      t.timestamps
    end
    
    add_foreign_key :actions, :communities
    add_foreign_key :actions, :action_types
    add_foreign_key :actions, :users
  end

  def self.down
    drop_table :actions
  end
end
