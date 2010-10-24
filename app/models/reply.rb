class Reply < ActiveRecord::Base
  belongs_to :discussion, :counter_cache => true
  belongs_to :user
  
  named_scope :ordered, :order => 'created_at ASC'
  
  validates_presence_of :discussion_id
  validates_presence_of :user_id
  validates_presence_of :body
  
  before_save :generate_html
  after_create :update_discussions_last_reply_at
  after_create :publish_action
  
  attr_accessor :first
  
  def generate_html
    self.body_as_html = RDiscount.new(body, :filter_html, :filter_styles, :autolink).to_html
  end
  
  def update_discussions_last_reply_at
    self.discussion.update_attribute(:last_reply_at, Time.now)
  end
  
  def publish_action
    unless self.first
      Action.publish(:type => :new_reply, :community => self.discussion.community, :user => self.user, :actionable => self.discussion)
    end
  end
end
