class Membership < ActiveRecord::Base
  belongs_to :community
  belongs_to :user
  
  named_scope :for_community, lambda {|community| {:conditions => {:community_id => community.id}}}
  named_scope :ordered, :order => 'id ASC'
  named_scope :with_id, lambda {|id| {:conditions => {:id => id}}}
  
  validates_presence_of :community_id
  validates_presence_of :user_id
  
  validates_inclusion_of :access, :in => [-1, 1]
  
  def manager?
    self.access > 0
  end
end
