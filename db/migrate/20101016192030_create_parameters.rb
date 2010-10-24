class CreateParameters < ActiveRecord::Migration
  def self.up
    create_table :parameters do |t|
      t.integer :resource_id
      t.integer :user_id
      t.integer :position
      t.string  :name
      t.text    :description
      t.boolean :required, :default => false, :null => false
      t.timestamps
    end
    
    add_foreign_key :parameters, :resources
    add_foreign_key :parameters, :users
  end

  def self.down
    drop_table :parameters
  end
end
