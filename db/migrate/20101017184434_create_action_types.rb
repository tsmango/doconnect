class CreateActionTypes < ActiveRecord::Migration
  def self.up
    create_table :action_types do |t|
      t.string  :name
      t.string  :image
      t.string  :template
      t.timestamps
    end
    
    ActionType.reset_column_information
    ActionType.create(:name => 'new_community',    :template => 'started the community {community}',        :image => 'actions/started-the-community.png')
    ActionType.create(:name => 'new_membership',   :template => 'joined the community {community}',         :image => 'actions/joined-the-community.png')
    ActionType.create(:name => 'updated_page',     :template => 'updated the page {page}',                  :image => 'actions/updated-the-page.png')
    ActionType.create(:name => 'updated_resource', :template => 'updated the documentation for {resource}', :image => 'actions/updated-the-documentation-for.png')
    ActionType.create(:name => 'new_discussion',   :template => 'started the discussion {discussion}',      :image => 'actions/started-the-discussion.png')
    ActionType.create(:name => 'new_reply',        :template => 'replied to the discussion {discussion}',   :image => 'actions/replied-to-the-discussion.png')
  end

  def self.down
    drop_table :action_types
  end
end
