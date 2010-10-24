class Discussion < ActiveRecord::Base
  scoped_search :on => [:title]
  scoped_search :on => [:body], :in => :replies
  
  belongs_to :community
  belongs_to :user
  
  has_many :replies, :dependent => :destroy
  
  named_scope :ordered, :order => 'sticky DESC, last_reply_at DESC'
  named_scope :with_id, lambda {|id| {:conditions => {:id => id}}}
  
  validates_presence_of :community_id
  validates_presence_of :user_id
  validates_presence_of :title
  validates_presence_of :slug
  validates_presence_of :body
  
  before_validation :generate_slug
  after_create :publish_action
  after_create :generate_reply
  
  attr_accessor :body
  
  def generate_slug
    self.slug = Util::Slug.generate(self.title) if !self.title.blank?
  end
  
  def publish_action
    Action.publish(:type => :new_discussion, :community => self.community, :user => self.user, :actionable => self)
  end
  
  def generate_reply
    reply = self.replies.new
    reply.user_id = self.user_id
    reply.body    = self.body
    reply.first   = true
    reply.save
  end
  
  def to_param
    "#{self.id.to_s}-#{self.slug}"
  end
end
