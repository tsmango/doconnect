class Community < ActiveRecord::Base
  belongs_to :user
  
  scoped_search :on => [:name, :subdomain]
  
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships
  
  has_many :pages, :order => 'pages.user_created ASC, lower(pages.name) ASC', :dependent => :destroy
  has_many :discussions, :order => 'discussions.last_reply_at DESC', :dependent => :destroy
  has_many :resources, :order => 'resources.path ASC', :dependent => :destroy
  
  has_many :actions, :dependent => :destroy
  
  named_scope :with_id, lambda {|id| {:conditions => {:id => id}}}
  named_scope :with_subdomain, lambda {|subdomain| {:conditions => {:subdomain => subdomain}}}
  
  validates_presence_of :name
  validates_presence_of :subdomain
  
  validates_uniqueness_of :subdomain, :on => :save, :message => 'must be unique and has already been used'
  validates_exclusion_of  :subdomain, :in => %w( support blog www billing help api admin ), :message => "'{{value}}' is reserved and unavailable"
  validates_format_of     :subdomain, :on => :save, :with => /^[A-Za-z0-9-]+$/, :message => 'can only contain alphanumeric characters and dashes'
  validates_length_of     :subdomain, :minimum => 3, :message => 'must be at least 3 characters long'
  
  validates_inclusion_of :privacy, :in => [-1, 0, 1]
  
  before_validation :downcase_subdomain
  after_create :create_initial_membership, :publish_action, :create_overview_page
  
  def downcase_subdomain
    self.subdomain.downcase! if attribute_present?("subdomain")
  end
  
  def create_initial_membership
    self.memberships.create(:user_id => self.user_id, :access => 1, :approved => true)
  end
  
  def create_overview_page
    self.pages.create(:user_id => self.user_id, :name => 'Overview', :body => '', :user_created => false)
  end
  
  def publish_action
    Action.publish(:type => :new_community, :community => self, :user => self.user, :actionable => self)
  end
  
  def open?
    self.privacy > 0
  end
  
  def closed?
    self.privacy == 0
  end
  
  def private?
    self.privacy < 0
  end
  
  def overview_page
    self.pages.with_slug('overview').first
  end
  
  def host
    return "#{self.subdomain}.#{BASE_DOMAIN}"
  end
  
  def url
    return "http://#{self.subdomain}.#{BASE_DOMAIN}"
  end
  
  def self.find_by_url(host, subdomain)
    Community.with_subdomain(subdomain).first
  end
end
