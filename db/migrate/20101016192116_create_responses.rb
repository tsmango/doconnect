class CreateResponses < ActiveRecord::Migration
  def self.up
    create_table :responses do |t|
      t.integer :resource_id
      t.integer :user_id
      t.integer :position
      t.string  :format
      t.string  :http_code
      t.text    :body
      t.timestamps
    end
    
    add_foreign_key :responses, :resources
    add_foreign_key :responses, :users
  end

  def self.down
    drop_table :responses
  end
end
