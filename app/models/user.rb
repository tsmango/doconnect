class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field = 'email_address'
    c.email_field = 'email_address'
    c.merge_validates_uniqueness_of_email_field_options :case_sensitive => false
  end
  
  is_gravtastic :email_address
  
  has_many :memberships
  has_many :communities, :through => :memberships, :order => 'lower(communities.name) ASC'
  
  named_scope :ordered, :order => 'id DESC'
  
  validates_presence_of :name
  
  def member_of?(community)
    self.memberships.for_community(community).first
  end
  
  def can_view?(community)
    community.open? or (community.closed? and member_of?(community)) or (member_of?(community) and member_of?(community).approved?)
  end
  
  def can_engage?(community)
    (community.private? and member_of?(community) and member_of?(community).approved?) or member_of?(community)
  end
  
  def can_manage?(community)
     member_of?(community) and  member_of?(community).manager?
  end
end
