class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string      :name
      t.string      :email_address,       :null => false
      t.string      :crypted_password,    :null => false
      t.string      :password_salt,       :null => false
      t.string      :persistence_token,   :null => false
      t.string      :perishable_token,    :null => false
      t.integer     :login_count,         :null => false, :default => 0
      t.integer     :failed_login_count,  :null => false, :default => 0
      t.timestamp   :current_login_at
      t.timestamp   :last_login_at
      t.string      :current_login_ip
      t.string      :last_login_ip
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
