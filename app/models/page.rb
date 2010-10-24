class Page < ActiveRecord::Base
  acts_as_list :scope => :community
  
  scoped_search :on => [:name]
  scoped_search :on => [:body], :in => :page_revisions
  
  belongs_to :community
  belongs_to :user
  
  has_many :page_revisions, :dependent => :destroy
  
  named_scope :with_slug, lambda {|slug| {:conditions => {:slug => slug}}}
  
  validates_presence_of :community_id
  validates_presence_of :user_id
  validates_presence_of :name
  validates_presence_of :slug
  
  validates_uniqueness_of :slug, :scope => :community_id
  
  before_validation :generate_slug
  before_validation :include_blank_slate
  after_save :generate_revision
  
  attr_accessor :body, :minor_revision
  
  def generate_slug
    self.slug = Util::Slug.generate(self.name) if !self.name.blank?
  end
  
  def include_blank_slate
    if self.new_record? and self.slug == 'overview' and !self.user_created? and self.body.blank?
      self.body = <<-EOF
Welcome to your community overview page! To edit this page, use the '[edit](/pages/overview/edit)' link on the top right. Here, you'll want to write a short description of your community and provide links back to your service and possibly call out some important Pages or Documentation from the sidebar.

Here are a few things you should know:

* Pages are versioned and support [Markdown](http://daringfireball.net/projects/markdown) formatting.
* Add a page by clicking the '[Add a Page](/pages/new)' link on the sidebar.
* Access community [Discussions](/discussions) from the sidebar.
* Manage your community's members from the [Memberships](/memberships) area.
* You can promote any member to a Community Manager.
* Community Managers can create Pages and Documentation as well as promote others.
* If your community is private, you'll be able to approve members from the Memberships area.
      EOF
    end
  end
  
  def generate_revision
    if self.minor_revision and self.minor_revision == '1' and self.last_revision
      revision = self.last_revision
      revision.body = self.body
      revision.save
    else
      revision = self.page_revisions.new
      revision.user_id = self.user_id
      revision.body = self.body
      revision.save
    end
  end
  
  def overview?
    self.slug == 'overview'
  end
  
  def last_revision
    return self.page_revisions.ordered.first
  end
  
  def to_param
    self.slug
  end
end
