class Action < ActiveRecord::Base
  belongs_to :community
  belongs_to :action_type
  belongs_to :user
  belongs_to :actionable, :polymorphic => true
  
  named_scope :in_communities, lambda {|community_ids| {:conditions => {:community_id => community_ids}}}
  named_scope :ordered, :order => 'id DESC'
  
  def self.publish(options = {})
    begin
      if options[:type] and type = ActionType.kind_of(options[:type])
        options.merge!(:community_id => options[:community].id)
        options.delete(:community)
        
        options.merge!(:user_id => options[:user].id)
        options.delete(:user)

        options.merge!(:action_type_id => type.id)
        options.delete(:type)

        options.merge!(:actionable_type => options[:actionable].class.name, :actionable_id => options[:actionable].id)
        options.delete(:actionable)

        Action.create(options)
      end
    rescue
    end
    
    return true
  end
end
