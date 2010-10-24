class PageRevision < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  
  named_scope :ordered, :order => 'id DESC'
  named_scope :with_id, lambda {|id| {:conditions => {:id => id}}}
  
  validates_presence_of :page_id
  validates_presence_of :user_id
  
  before_save :generate_html
  after_create :publish_action
  
  def generate_html
    self.body ||= ''
    self.body_as_html = RDiscount.new(body, :filter_html, :filter_styles, :autolink).to_html
  end
  
  def publish_action
    Action.publish(:type => :updated_page, :community => self.page.community, :user => self.page.user, :actionable => self.page)
  end
end
